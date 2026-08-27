# The following locals block constructs derived values used throughout this configuration.

locals {
  azdo_org_service_url = "${var.azuredevops_service_url}/${var.azuredevops_organization}"

  # identifier — machine-readable URL used by the HCP Terraform provider to locate the repo.
  # Format: <org>/<project%20encoded>/_git/<repo>
  vcs_identifier = length(module.modules_factory_repository) > 0 ? "${var.azuredevops_organization}/${replace(var.azuredevops_project_name, " ", "%20")}/_git/${module.modules_factory_repository[0].repository.name}" : null

  # display_identifier — human-readable label shown in the HCP Terraform UI.
  # Format: <org>/<project with spaces>/<repo>  (no /_git/ segment, no URL-encoding)
  vcs_display_identifier = length(module.modules_factory_repository) > 0 ? "${var.azuredevops_organization}/${var.azuredevops_project_name}/${module.modules_factory_repository[0].repository.name}" : null
}

# The following data source looks up the Azure DevOps project by name to obtain its UUID,
# which is required by all azuredevops_* resources.

data "azuredevops_project" "this" {
  name = var.azuredevops_project_name
}

# The following code block is used to create and manage the project where all the workspaces related to the published modules will be stored.

resource "tfe_project" "this" {
  count        = var.project_name != null ? 1 : 0
  name         = var.project_name
  organization = var.organization_name
  description  = var.project_description
  tags = merge(var.project_tags, {
    managed_by_terraform = "true"
  })
}

# The following code block is used to create and manage the variable set at the project level that will own the variables required by the child workspaces.

resource "tfe_variable_set" "this" {
  count             = length(tfe_project.this) > 0 ? 1 : 0
  name              = lower(replace("${tfe_project.this[0].name}-hcp", "/\\W|_|\\s/", "-"))
  description       = "Variable set for project \"${tfe_project.this[0].name}\"."
  organization      = var.organization_name
  parent_project_id = tfe_project.this[0].id
}

# The following resource blocks are used to create variables that will be stored into the variable set previously created.

resource "tfe_variable" "azdo_org_service_url" {
  count           = length(tfe_variable_set.this) > 0 ? 1 : 0
  key             = "AZDO_ORG_SERVICE_URL"
  value           = local.azdo_org_service_url
  category        = "env"
  sensitive       = false
  variable_set_id = tfe_variable_set.this[0].id
}

resource "tfe_variable" "azdo_personal_access_token" {
  count           = length(tfe_variable_set.this) > 0 ? 1 : 0
  key             = "AZDO_PERSONAL_ACCESS_TOKEN"
  value           = var.azuredevops_personal_access_token
  category        = "env"
  sensitive       = true
  variable_set_id = tfe_variable_set.this[0].id
}

resource "tfe_variable" "azdo_project_name" {
  count           = length(tfe_variable_set.this) > 0 ? 1 : 0
  key             = "azdo_project_name"
  value           = var.azuredevops_project_name
  category        = "terraform"
  description     = "(Required) Name of the Azure DevOps project where repositories will be created."
  sensitive       = false
  variable_set_id = tfe_variable_set.this[0].id
}

resource "tfe_variable" "oauth_client_name" {
  count           = length(tfe_variable_set.this) > 0 ? 1 : 0
  key             = "oauth_client_name"
  value           = var.oauth_client_name
  category        = "terraform"
  description     = "(Optional) Name of the OAuth client."
  sensitive       = false
  variable_set_id = tfe_variable_set.this[0].id
}

resource "tfe_variable" "organization" {
  count           = length(tfe_variable_set.this) > 0 ? 1 : 0
  key             = "organization"
  value           = var.organization_name
  category        = "terraform"
  description     = "(Optional) HCP Terraform organization name."
  sensitive       = false
  variable_set_id = tfe_variable_set.this[0].id
}

resource "tfe_variable" "module_name" {
  count           = length(tfe_variable_set.this) > 0 ? 1 : 0
  key             = "module_name"
  value           = var.module_name
  category        = "terraform"
  description     = "(Required) The name of the Terraform module."
  sensitive       = false
  variable_set_id = tfe_variable_set.this[0].id
}

resource "tfe_variable" "module_provider" {
  count           = length(tfe_variable_set.this) > 0 ? 1 : 0
  key             = "module_provider"
  value           = var.module_provider
  category        = "terraform"
  description     = "(Required) The main provider the module uses (e.g., `tfe`, `azurerm`, `aws`)."
  sensitive       = false
  variable_set_id = tfe_variable_set.this[0].id
}

resource "tfe_variable" "tfe_token" {
  count           = length(tfe_variable_set.this) > 0 ? 1 : 0
  key             = "TFE_TOKEN"
  value           = var.tfe_token
  category        = "env"
  sensitive       = true
  variable_set_id = tfe_variable_set.this[0].id
}

# The following module block is used to create and manage the Azure DevOps repository that will contain the Terraform module used by the factory.

module "modules_factory_repository" {
  source     = "./modules/azuredevops_repository"
  count      = length(tfe_project.this) > 0 ? 1 : 0
  name       = var.module_name
  project_id = data.azuredevops_project.this.id
}

# The following code block is used to create module resources in the private registry.

resource "tfe_registry_module" "this" {
  count           = length(module.modules_factory_repository) > 0 ? 1 : 0
  organization    = var.organization_name
  initial_version = "0.0.0"
  test_config {
    tests_enabled = true
  }
  vcs_repo {
    display_identifier = local.vcs_display_identifier
    identifier         = local.vcs_identifier
    oauth_token_id     = var.vcs_oauth_token_id
    branch             = "main"
  }
}

resource "tfe_no_code_module" "this" {
  count           = length(tfe_registry_module.this) > 0 ? 1 : 0
  organization    = var.organization_name
  registry_module = tfe_registry_module.this[0].id
}

resource "tfe_test_variable" "azdo_org_service_url" {
  count           = length(tfe_registry_module.this) > 0 ? 1 : 0
  key             = "AZDO_ORG_SERVICE_URL"
  value           = local.azdo_org_service_url
  category        = "env"
  module_name     = tfe_registry_module.this[0].name
  module_provider = tfe_registry_module.this[0].module_provider
  organization    = var.organization_name
  sensitive       = false
}

resource "tfe_test_variable" "azdo_personal_access_token" {
  count           = length(tfe_registry_module.this) > 0 ? 1 : 0
  key             = "AZDO_PERSONAL_ACCESS_TOKEN"
  value           = var.azuredevops_personal_access_token
  category        = "env"
  module_name     = tfe_registry_module.this[0].name
  module_provider = tfe_registry_module.this[0].module_provider
  organization    = var.organization_name
  sensitive       = true
}

resource "tfe_test_variable" "azdo_organization" {
  count           = length(tfe_registry_module.this) > 0 ? 1 : 0
  key             = "TF_VAR_azuredevops_organization"
  value           = var.azuredevops_organization
  category        = "env"
  module_name     = tfe_registry_module.this[0].name
  module_provider = tfe_registry_module.this[0].module_provider
  organization    = var.organization_name
  sensitive       = false
}

resource "tfe_test_variable" "azdo_project_name" {
  count           = length(tfe_registry_module.this) > 0 ? 1 : 0
  key             = "TF_VAR_azdo_project_name"
  value           = var.azuredevops_project_name
  category        = "env"
  module_name     = tfe_registry_module.this[0].name
  module_provider = tfe_registry_module.this[0].module_provider
  organization    = var.organization_name
  sensitive       = false
}

resource "tfe_test_variable" "azdo_personal_access_token_var" {
  count           = length(tfe_registry_module.this) > 0 ? 1 : 0
  key             = "TF_VAR_azuredevops_personal_access_token"
  value           = var.azuredevops_personal_access_token
  category        = "env"
  module_name     = tfe_registry_module.this[0].name
  module_provider = tfe_registry_module.this[0].module_provider
  organization    = var.organization_name
  sensitive       = true
}

resource "tfe_test_variable" "oauth_client_name" {
  count           = length(tfe_registry_module.this) > 0 ? 1 : 0
  key             = "TF_VAR_oauth_client_name"
  value           = var.oauth_client_name
  category        = "env"
  module_name     = tfe_registry_module.this[0].name
  module_provider = tfe_registry_module.this[0].module_provider
  organization    = var.organization_name
  sensitive       = false
}

resource "tfe_test_variable" "organization" {
  count           = length(tfe_registry_module.this) > 0 ? 1 : 0
  key             = "TF_VAR_organization"
  value           = var.organization_name
  category        = "env"
  module_name     = tfe_registry_module.this[0].name
  module_provider = tfe_registry_module.this[0].module_provider
  organization    = var.organization_name
  sensitive       = false
}

resource "tfe_test_variable" "tfe_token" {
  count           = length(tfe_registry_module.this) > 0 ? 1 : 0
  key             = "TFE_TOKEN"
  value           = var.tfe_token
  category        = "env"
  module_name     = tfe_registry_module.this[0].name
  module_provider = tfe_registry_module.this[0].module_provider
  organization    = var.organization_name
  sensitive       = true
}

resource "tfe_test_variable" "module_name" {
  count           = length(tfe_registry_module.this) > 0 ? 1 : 0
  key             = "TF_VAR_module_name"
  value           = var.module_name
  category        = "env"
  module_name     = tfe_registry_module.this[0].name
  module_provider = tfe_registry_module.this[0].module_provider
  organization    = var.organization_name
  sensitive       = false
}

resource "tfe_test_variable" "module_provider" {
  count           = length(tfe_registry_module.this) > 0 ? 1 : 0
  key             = "TF_VAR_module_provider"
  value           = var.module_provider
  category        = "env"
  module_name     = tfe_registry_module.this[0].name
  module_provider = tfe_registry_module.this[0].module_provider
  organization    = var.organization_name
  sensitive       = false
}

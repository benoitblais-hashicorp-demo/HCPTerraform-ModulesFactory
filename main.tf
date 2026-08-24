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

resource "tfe_variable" "tfe_token" {
  count           = length(tfe_variable_set.this) > 0 ? 1 : 0
  key             = "TFE_TOKEN"
  value           = var.tfe_token
  category        = "env"
  sensitive       = true
  variable_set_id = tfe_variable_set.this[0].id
}

resource "tfe_variable" "azdo_org_service_url" {
  count           = length(tfe_variable_set.this) > 0 ? 1 : 0
  key             = "AZDO_ORG_SERVICE_URL"
  value           = var.azdo_org_service_url
  category        = "env"
  sensitive       = false
  variable_set_id = tfe_variable_set.this[0].id
}

resource "tfe_variable" "azdo_personal_access_token" {
  count           = length(tfe_variable_set.this) > 0 ? 1 : 0
  key             = "AZDO_PERSONAL_ACCESS_TOKEN"
  value           = var.azdo_personal_access_token
  category        = "env"
  sensitive       = true
  variable_set_id = tfe_variable_set.this[0].id
}

resource "tfe_variable" "oauth_client_name" {
  count           = length(tfe_variable_set.this) > 0 ? 1 : 0
  key             = "oauth_client_name"
  value           = var.oauth_client_name
  category        = "terraform"
  description     = "(Optional) Name of the OAuth client."
  variable_set_id = tfe_variable_set.this[0].id
}

resource "tfe_variable" "organization" {
  count           = length(tfe_variable_set.this) > 0 ? 1 : 0
  key             = "organization"
  value           = var.organization_name
  category        = "terraform"
  description     = "(Optional) HCP Terraform organization name."
  variable_set_id = tfe_variable_set.this[0].id
}

resource "tfe_variable" "azdo_project_name" {
  count           = length(tfe_variable_set.this) > 0 ? 1 : 0
  key             = "azdo_project_name"
  value           = var.azdo_project_name
  category        = "terraform"
  description     = "(Required) Name of the Azure DevOps project where repositories will be created."
  variable_set_id = tfe_variable_set.this[0].id
}

# The following module block is used to create and manage the Azure DevOps repository that will contain the Terraform module used by the factory.

module "modules_factory_repository" {
  source       = "./modules/azuredevops_repository"
  count        = length(tfe_project.this) > 0 && var.module_name != null ? 1 : 0
  name         = var.module_name
  description  = "Terraform module to manage ${element(split("-", var.module_name), 1)} resources."
  project_id   = var.azdo_project_id
  project_name = var.azdo_project_name
  ado_org_name = var.azdo_org_name
}

# The following block is used to get information about an OAuth client.

data "tfe_oauth_client" "client" {
  count        = var.oauth_client_name != null ? 1 : 0
  organization = var.organization_name
  name         = var.oauth_client_name
}

# The following code block is used to create module resources in the private registry.

resource "tfe_registry_module" "this" {
  count           = length(module.modules_factory_repository) > 0 && length(data.tfe_oauth_client.client) > 0 ? 1 : 0
  organization    = var.organization_name
  initial_version = "0.0.0"
  test_config {
    tests_enabled = true
  }
  vcs_repo {
    display_identifier = module.modules_factory_repository[0].full_name
    identifier         = module.modules_factory_repository[0].full_name
    oauth_token_id     = data.tfe_oauth_client.client[0].oauth_token_id
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
  value           = var.azdo_org_service_url
  category        = "env"
  module_name     = tfe_registry_module.this[0].name
  module_provider = tfe_registry_module.this[0].module_provider
  organization    = var.organization_name
  sensitive       = false
}

resource "tfe_test_variable" "azdo_personal_access_token" {
  count           = length(tfe_registry_module.this) > 0 ? 1 : 0
  key             = "AZDO_PERSONAL_ACCESS_TOKEN"
  value           = var.azdo_personal_access_token
  category        = "env"
  module_name     = tfe_registry_module.this[0].name
  module_provider = tfe_registry_module.this[0].module_provider
  organization    = var.organization_name
  sensitive       = true
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

resource "tfe_test_variable" "oauth_client_name" {
  key             = "TF_VAR_oauth_client_name"
  value           = var.oauth_client_name
  category        = "env"
  module_name     = tfe_registry_module.this[0].name
  module_provider = tfe_registry_module.this[0].module_provider
  organization    = var.organization_name
}

resource "tfe_test_variable" "organization" {
  key             = "TF_VAR_organization"
  value           = var.organization_name
  category        = "env"
  module_name     = tfe_registry_module.this[0].name
  module_provider = tfe_registry_module.this[0].module_provider
  organization    = var.organization_name
}

resource "tfe_test_variable" "azdo_project_name" {
  key             = "TF_VAR_azdo_project_name"
  value           = var.azdo_project_name
  category        = "env"
  module_name     = tfe_registry_module.this[0].name
  module_provider = tfe_registry_module.this[0].module_provider
  organization    = var.organization_name
}

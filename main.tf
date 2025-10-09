# The following code block is used to create and manage the project where all the workspaces related to the published modules will be stored.

resource "tfe_project" "this" {
  count        = var.project_name != null ? 1 : 0
  name         = var.project_name
  organization = var.organization
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
  organization      = var.organization
  parent_project_id = tfe_project.this[0].id
}

# The following module blocks are used to create and manage the HCP Terraform teams required by the `modules factory`.

module "modules_factory_team_hcp" {
  source       = "./modules/tfe_team"
  count        = length(tfe_project.this) > 0 ? 1 : 0
  name         = lower(replace("${tfe_project.this[0].name}-hcp", "/\\W|_|\\s/", "-"))
  organization = var.organization
  organization_access = {
    manage_modules = true
  }
  token = true
}

# The following resource blocks are used to create variables that will be stored into the variable set previously created.

resource "tfe_variable" "tfe_token" {
  count           = length(module.modules_factory_team_hcp) > 0 ? 1 : 0
  key             = "TFE_TOKEN"
  value           = module.modules_factory_team_hcp[0].token
  category        = "env"
  sensitive       = true
  variable_set_id = tfe_variable_set.this[0].id
}

resource "tfe_variable" "github_app_id" {
  count           = length(tfe_variable_set.this) > 0 ? 1 : 0
  key             = "GITHUB_APP_ID"
  value           = var.app_id
  category        = "env"
  sensitive       = true
  variable_set_id = tfe_variable_set.this[0].id
}

resource "tfe_variable" "github_app_installation_id" {
  count           = length(tfe_variable_set.this) > 0 ? 1 : 0
  key             = "GITHUB_APP_INSTALLATION_ID"
  value           = var.app_installation_id
  category        = "env"
  sensitive       = true
  variable_set_id = tfe_variable_set.this[0].id
}

resource "tfe_variable" "github_app_pem_file" {
  count           = length(tfe_variable_set.this) > 0 ? 1 : 0
  key             = "GITHUB_APP_PEM_FILE"
  value           = var.app_pem_file
  category        = "env"
  sensitive       = true
  variable_set_id = tfe_variable_set.this[0].id
}

resource "tfe_variable" "github_owner" {
  count           = length(tfe_variable_set.this) > 0 ? 1 : 0
  key             = "GITHUB_OWNER"
  value           = var.github_organization
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
  value           = var.organization
  category        = "terraform"
  description     = "(Optional) A description for the project."
  variable_set_id = tfe_variable_set.this[0].id
}

# The following module block is used to create and manage the GitHub repository that will contain the Terraform module used by the facotry.

module "modules_factory_repository" {
  source      = "./modules/git_repository"
  count       = length(tfe_project.this) > 0 && var.module_name != null ? 1 : 0
  name        = var.module_name
  description = "Terraform module to manage ${element(split("-", var.module_name), 1)} resources."
  topics      = ["factory", "terraform-module", "terraform", "terraform-managed"]
}


# The following module block is used to create and manage a GitHub team for the `modules factory`.

module "policies_factory_git_teams" {
  for_each    = { for team in var.github_teams : team.name => team }
  source      = "./modules/git_team"
  name        = each.value.name
  description = try(each.value.description, null)
  permission  = try(each.value.permission, null)
  repository  = module.modules_factory_repository[0].repository.name
}

# The following block is use to get information about an OAuth client.

data "tfe_oauth_client" "client" {
  count        = var.oauth_client_name != null ? 1 : 0
  organization = var.organization
  name         = var.oauth_client_name
}

# The following code block is used to create module resources in the private registry.

resource "tfe_registry_module" "this" {
  count           = length(module.modules_factory_repository) > 0 && length(data.tfe_oauth_client.client) > 0 ? 1 : 0
  organization    = var.organization
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
  organization    = var.organization
  registry_module = tfe_registry_module.this[0].id
}

resource "tfe_test_variable" "github_app_id" {
  key             = "GITHUB_APP_ID"
  value           = var.app_id
  category        = "env"
  module_name     = tfe_registry_module.this[0].name
  module_provider = tfe_registry_module.this[0].module_provider
  organization    = var.organization
  sensitive       = true
}

resource "tfe_test_variable" "github_app_installation_id" {
  key             = "GITHUB_APP_INSTALLATION_ID"
  value           = var.app_installation_id
  category        = "env"
  module_name     = tfe_registry_module.this[0].name
  module_provider = tfe_registry_module.this[0].module_provider
  organization    = var.organization
  sensitive       = true
}

resource "tfe_test_variable" "github_app_pem_file" {
  key             = "GITHUB_APP_PEM_FILE"
  value           = var.app_pem_file
  category        = "env"
  module_name     = tfe_registry_module.this[0].name
  module_provider = tfe_registry_module.this[0].module_provider
  organization    = var.organization
  sensitive       = true
}

resource "tfe_test_variable" "github_owner" {
  key             = "GITHUB_OWNER"
  value           = var.github_organization
  category        = "env"
  module_name     = tfe_registry_module.this[0].name
  module_provider = tfe_registry_module.this[0].module_provider
  organization    = var.organization
  sensitive       = true
}

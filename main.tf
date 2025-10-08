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
  name              = tfe_project.this[0].name
  description       = "Variable set for projecy ${tfe_project.this[0].name}"
  organization      = var.organization
  parent_project_id = tfe_project.this[0].id
}

# The following module blocks are used to create and manage the HCP Terraform teams required by the `modules factory`.

module "modules_factory_team_hcp" {
  source       = "./modules/tfe_team"
  count        = length(tfe_project.this) > 0 ? 1 : 0
  name         = lower("${tfe_project.this[0].name}-hcp")
  organization = var.organization
  organization_access = {
    manage_modules    = true
  }
  token = true
}

module "modules_factory_team_git" {
  source         = "./modules/tfe_team"
  count          = length(tfe_project.this) > 0 ? 1 : 0
  name           = lower("${tfe_project.this[0].name}-git")
  organization   = var.organization
  token          = true
  project_id     = tfe_project.this[0].id
  project_access = "custom"
  custom_workspace_access = {
    runs = "apply"
  }
}
provider "tfe" {}

provider "azuredevops" {
  org_service_url       = var.azdo_org_service_url
  personal_access_token = var.azdo_personal_access_token
}

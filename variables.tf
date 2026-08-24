variable "azdo_org_name" {
  description = "(Required) The short name (slug) of the Azure DevOps organization as it appears in the org URL (e.g. \"myorg\" for https://dev.azure.com/myorg). Used to construct VCS identifiers."
  type        = string
  nullable    = false
}

variable "azdo_org_service_url" {
  description = "(Required) The URL of the Azure DevOps organization (e.g. https://dev.azure.com/myorg). Can also be set via the AZDO_ORG_SERVICE_URL environment variable."
  type        = string
  nullable    = false
}

variable "azdo_personal_access_token" {
  description = "(Required) The Azure DevOps Personal Access Token used to authenticate. Can also be set via the AZDO_PERSONAL_ACCESS_TOKEN environment variable."
  type        = string
  nullable    = false
  sensitive   = true
}

variable "azdo_project_id" {
  description = "(Required) The ID of the Azure DevOps project where the factory repository will be created."
  type        = string
  nullable    = false
}

variable "azdo_project_name" {
  description = "(Required) The name of the Azure DevOps project where repositories will be created by the no-code module workspaces."
  type        = string
  nullable    = false
}

variable "organization_name" {
  description = "(Required) Name of the HCP Terraform organization."
  type        = string
  nullable    = false
}

variable "tfe_token" {
  description = "(Required) HCP Terraform API token used by child workspaces to publish modules into the private registry."
  type        = string
  nullable    = false
  sensitive   = true
}

variable "module_name" {
  description = "(Optional) Name of the terraform module used by the modules factory."
  type        = string
  default     = "terraform-azuredevops-modulesfactory"
}

variable "oauth_client_name" {
  description = "(Optional) Name of the OAuth client used to connect HCP Terraform to the Azure DevOps VCS provider."
  type        = string
  nullable    = false
  default     = "AzureDevOps"
}

variable "project_description" {
  description = "(Optional) A description for the project."
  type        = string
  nullable    = true
  default     = null
}

variable "project_name" {
  description = "(Optional) Name of the HCP Terraform project."
  type        = string
  nullable    = true
  default     = "Terraform Modules Factory"
}

variable "project_tags" {
  description = "(Optional) A map of key-value tags to add to the project."
  type        = map(string)
  nullable    = true
  default     = null
}

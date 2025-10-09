variable "organization" {
  description = "(Optional) A description for the project."
  type        = string
  nullable    = false
  default     = "benoitblais-hashicorp"
}

variable "project_description" {
  description = "(Optional) A description for the project."
  type        = string
  nullable    = true
  default     = null
}

variable "project_name" {
  description = "(Optional) Name of the project."
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

variable "module_name" {
  description = "(Optional) Name of the terraform module used by the modules factory."
  type        = string
  default     = "terraform-tfe-modulesfactory"
}

variable "oauth_client_name" {
  description = "(Optional) Name of the OAuth client."
  type        = string
  nullable    = false
  default     = "GitHub"
}

variable "github_organization" {
  description = "(Required) The target GitHub organization or individual user account to manage."
  type        = string
  nullable    = false
  sensitive   = true
}

variable "app_id" {
  description = "(Required) ID of the GitHub App used to authenticate."
  type        = string
  nullable    = false
  sensitive   = true
}

variable "app_installation_id" {
  description = "(Required) ID of the GitHub App installation used to authenticate."
  type        = string
  nullable    = false
  sensitive   = true
}

variable "app_pem_file" {
  description = "(Required) Content of the GitHub App private key PEM file used to authenticate."
  type        = string
  nullable    = false
  sensitive   = true
}
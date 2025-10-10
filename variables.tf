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

variable "github_teams" {
  description = <<EOT
  (Optional) The github_teams block supports the following:
    name        : (Required) The name of the team.
    description : (Optional) A description of the team.
    permission  : (Optional) The permissions of team members regarding the repository. Must be one of `pull`, `triage`, `push`, `maintain`, `admin` or the name of an existing custom repository role within the organisation.
  EOT
  type = list(object({
    name        = string
    description = optional(string)
    permission  = optional(string, "pull")
  }))
  nullable = false
  default = [{
    name        = "Terraform-Modules-Owners"
    description = "This group grant admin access to the Terraform Modules repository."
    permission  = "admin"
    },
    {
      name        = "Terraform-Modules-Contributors"
      description = "This group grant write access to the Terraform Modules repository."
      permission  = "push"
  }]
}

variable "github_template" {
  description = "(Optional) The GitHub repository to use as a template when creating new repositories. The repository must be a template repository. If not provided, the default template provided by the module will be used."
  type        = string
  nullable    = true
  default     = null
}
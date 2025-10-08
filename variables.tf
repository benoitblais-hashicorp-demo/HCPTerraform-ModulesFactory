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
  default     = "TerraformModulesFactory"
}

variable "project_tags" {
  description = "(Optional) A map of key-value tags to add to the project."
  type        = map(string)
  nullable    = true
  default     = null
}


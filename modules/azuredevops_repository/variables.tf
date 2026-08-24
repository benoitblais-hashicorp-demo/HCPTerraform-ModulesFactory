variable "project_id" {
  description = "(Required) The ID of the Azure DevOps project in which to create the repository."
  type        = string
  nullable    = false
}

variable "project_name" {
  description = "(Required) The name of the Azure DevOps project. Used to construct the HCP Terraform VCS identifier."
  type        = string
  nullable    = false
}

variable "ado_org_name" {
  description = "(Required) The name of the Azure DevOps organization (the slug that appears in the org URL). Used to construct the HCP Terraform VCS identifier."
  type        = string
  nullable    = false
}

variable "name" {
  description = "(Required) The name of the Azure DevOps Git repository."
  type        = string
  nullable    = false
}

variable "description" {
  description = "(Optional) A description for the repository. Note: Azure DevOps does not expose a native description field on Git repositories; this variable is accepted for interface parity."
  type        = string
  default     = null
}

variable "branch_policies" {
  description = <<EOT
  (Optional) List of branch policy configurations to apply to this repository.
  Each entry targets one branch (ref) and can enable up to three policy types:

    ref                             : (Required) Branch name (e.g. "main") or full ref (e.g. "refs/heads/main").
    enabled                         : (Optional) Whether the policies are enabled. Defaults to true.
    blocking                        : (Optional) Whether the policies are blocking (prevent completion). Defaults to true.
    require_conversation_resolution : (Optional) All PR comments must be resolved before merge. Defaults to false.
    required_pull_request_reviews   : (Optional) Minimum-reviewers policy. Omit entirely to skip.
      required_approving_review_count : (Required) Minimum number of approvals required (0–N).
      dismiss_stale_reviews           : (Optional) Reset approval votes when new commits are pushed. Defaults to false.
      require_last_push_approval      : (Optional) The last pusher cannot approve their own changes. Defaults to false.
    merge_types                     : (Optional) Allowed merge strategies. Omit entirely to skip.
      allow_squash                  : (Optional) Allow squash merge. Defaults to false.
      allow_rebase_and_fast_forward : (Optional) Allow rebase with fast-forward. Defaults to false.
      allow_basic_no_fast_forward   : (Optional) Allow basic merge commit (no fast-forward). Defaults to true.
      allow_rebase_with_merge       : (Optional) Allow rebase with merge commit. Defaults to false.
  EOT
  type = list(object({
    ref                             = string
    enabled                         = optional(bool, true)
    blocking                        = optional(bool, true)
    require_conversation_resolution = optional(bool, false)
    required_pull_request_reviews = optional(object({
      required_approving_review_count = optional(number, 1)
      dismiss_stale_reviews           = optional(bool, false)
      require_last_push_approval      = optional(bool, false)
    }), null)
    merge_types = optional(object({
      allow_squash                  = optional(bool, false)
      allow_rebase_and_fast_forward = optional(bool, false)
      allow_basic_no_fast_forward   = optional(bool, true)
      allow_rebase_with_merge       = optional(bool, false)
    }), null)
  }))
  nullable = false
  default = [
    {
      ref                             = "main"
      enabled                         = true
      blocking                        = true
      require_conversation_resolution = true
      required_pull_request_reviews = {
        required_approving_review_count = 1
        dismiss_stale_reviews           = true
        require_last_push_approval      = false
      }
      merge_types = null
    }
  ]
}

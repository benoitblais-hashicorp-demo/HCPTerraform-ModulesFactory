# Azure DevOps repository Terraform module

Azure DevOps repository module which manages configuration and life-cycle
of your Azure DevOps Git repository, including branch policies.

## Permissions

To manage the Azure DevOps resources, provide a Personal Access Token (PAT)
from an account with appropriate permissions. The PAT should have:

* **Code**: Read, Create & Manage

## Authentication

The Azure DevOps provider requires either a Personal Access Token or a
Service Principal in order to manage resources.

There are several ways to provide the required token:

- Set the `personal_access_token` argument in the provider configuration.
  Use an input variable for the token.
- Set the `AZDO_PERSONAL_ACCESS_TOKEN` environment variable. The provider
  can read the `AZDO_PERSONAL_ACCESS_TOKEN` environment variable and the
  token stored there to authenticate.

The organization URL is also required:

- Set the `org_service_url` argument in the provider configuration.
- Set the `AZDO_ORG_SERVICE_URL` environment variable.

## Features

- Create and manage Git repositories within an Azure DevOps project.
- Configure branch policies per branch:
  - **Minimum reviewers** — required approving review count, stale-vote
    reset on push, and last-pusher approval restriction.
  - **Comment resolution** — all PR comments must be resolved before merge.
  - **Merge types** — restrict which merge strategies are permitted.

## Usage example

```hcl
module "repository" {
  source = "./modules/azuredevops_repository"

  project_id   = "00000000-0000-0000-0000-000000000000"
  project_name = "My ADO Project"
  ado_org_name = "myorg"
  name         = "terraform-azuredevops-mymodule"
  description  = "Terraform module to manage mymodule resources."

  branch_policies = [
    {
      ref                             = "main"
      require_conversation_resolution = true
      required_pull_request_reviews = {
        required_approving_review_count = 1
        dismiss_stale_reviews           = true
        require_last_push_approval      = false
      }
      merge_types = {
        allow_squash                  = true
        allow_rebase_and_fast_forward = false
        allow_basic_no_fast_forward   = true
        allow_rebase_with_merge       = false
      }
    }
  ]
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.13.0)

- <a name="requirement_azuredevops"></a> [azuredevops](#requirement\_azuredevops) (~> 1.16)

## Providers

The following providers are used by this module:

- <a name="provider_azuredevops"></a> [azuredevops](#provider\_azuredevops) (~> 1.16)

## Resources

The following resources are used by this module:

- [azuredevops_git_repository.this](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/git_repository) (resource)
- [azuredevops_branch_policy_min_reviewers.this](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/branch_policy_min_reviewers) (resource)
- [azuredevops_branch_policy_comment_resolution.this](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/branch_policy_comment_resolution) (resource)
- [azuredevops_branch_policy_merge_types.this](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/resources/branch_policy_merge_types) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_project_id"></a> [project\_id](#input\_project\_id)

Description: (Required) The ID of the Azure DevOps project in which to create the repository.

Type: `string`

### <a name="input_project_name"></a> [project\_name](#input\_project\_name)

Description: (Required) The name of the Azure DevOps project. Used to construct the HCP Terraform VCS identifier.

Type: `string`

### <a name="input_ado_org_name"></a> [ado\_org\_name](#input\_ado\_org\_name)

Description: (Required) The name of the Azure DevOps organization (the slug that appears in the org URL). Used to construct the HCP Terraform VCS identifier.

Type: `string`

### <a name="input_name"></a> [name](#input\_name)

Description: (Required) The name of the Azure DevOps Git repository.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_description"></a> [description](#input\_description)

Description: (Optional) A description for the repository. Note: Azure DevOps does not expose a native description field on Git repositories; this variable is accepted for interface parity.

Type: `string`

Default: `null`

### <a name="input_branch_policies"></a> [branch\_policies](#input\_branch\_policies)

Description: (Optional) List of branch policy configurations to apply to this repository.
Each entry targets one branch (ref) and can enable up to three policy types:

- `ref` : (Required) Branch name (e.g. `"main"`) or full ref (e.g. `"refs/heads/main"`).
- `enabled` : (Optional) Whether the policies are enabled. Defaults to `true`.
- `blocking` : (Optional) Whether the policies are blocking (prevent completion). Defaults to `true`.
- `require_conversation_resolution` : (Optional) All PR comments must be resolved before merge. Defaults to `false`.
- `required_pull_request_reviews` : (Optional) Minimum-reviewers policy. Omit entirely to skip.
  - `required_approving_review_count` : (Optional) Minimum number of approvals required. Defaults to `1`.
  - `dismiss_stale_reviews` : (Optional) Reset approval votes when new commits are pushed. Defaults to `false`.
  - `require_last_push_approval` : (Optional) The last pusher cannot approve their own changes. Defaults to `false`.
- `merge_types` : (Optional) Allowed merge strategies. Omit entirely to skip.
  - `allow_squash` : (Optional) Allow squash merge. Defaults to `false`.
  - `allow_rebase_and_fast_forward` : (Optional) Allow rebase with fast-forward. Defaults to `false`.
  - `allow_basic_no_fast_forward` : (Optional) Allow basic merge commit (no fast-forward). Defaults to `true`.
  - `allow_rebase_with_merge` : (Optional) Allow rebase with merge commit. Defaults to `false`.

Type:

```hcl
list(object({
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
```

Default:

```json
[
  {
    "ref": "main",
    "enabled": true,
    "blocking": true,
    "require_conversation_resolution": true,
    "required_pull_request_reviews": {
      "required_approving_review_count": 1,
      "dismiss_stale_reviews": true,
      "require_last_push_approval": false
    },
    "merge_types": null
  }
]
```

## Outputs

The following outputs are exported:

### <a name="output_id"></a> [id](#output\_id)

Description: The ID of the Azure DevOps Git repository.

### <a name="output_full_name"></a> [full\_name](#output\_full\_name)

Description: VCS identifier for HCP Terraform in the form `<ado_org>/<ado_project>/_git/<repo_name>` as required by `tfe_registry_module`.

### <a name="output_branch_policies"></a> [branch\_policies](#output\_branch\_policies)

Description: Map of all branch policy resource objects managed by this module, keyed by branch ref. Contains three sub-maps: `min_reviewers`, `comment_resolution`, and `merge_types`.

### <a name="output_remote_url"></a> [remote\_url](#output\_remote\_url)

Description: Git HTTPS URL of the repository.

### <a name="output_ssh_url"></a> [ssh\_url](#output\_ssh\_url)

Description: Git SSH URL of the repository.

### <a name="output_web_url"></a> [web\_url](#output\_web\_url)

Description: Web link to the repository.
<!-- END_TF_DOCS -->

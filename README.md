<!-- BEGIN_TF_DOCS -->


## Documentation

## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.13.0)

- <a name="requirement_github"></a> [github](#requirement\_github) (~>6.6)

- <a name="requirement_tfe"></a> [tfe](#requirement\_tfe) (~>0.70)

## Modules

The following Modules are called:

### <a name="module_modules_factory_repository"></a> [modules\_factory\_repository](#module\_modules\_factory\_repository)

Source: ./modules/git_repository

Version:

### <a name="module_modules_factory_team_git"></a> [modules\_factory\_team\_git](#module\_modules\_factory\_team\_git)

Source: ./modules/tfe_team

Version:

### <a name="module_modules_factory_team_hcp"></a> [modules\_factory\_team\_hcp](#module\_modules\_factory\_team\_hcp)

Source: ./modules/tfe_team

Version:

### <a name="module_policies_factory_git_teams"></a> [policies\_factory\_git\_teams](#module\_policies\_factory\_git\_teams)

Source: ./modules/git_team

Version:

## Required Inputs

The following input variables are required:

### <a name="input_app_id"></a> [app\_id](#input\_app\_id)

Description: (Required) ID of the GitHub App used to authenticate.

Type: `string`

### <a name="input_app_installation_id"></a> [app\_installation\_id](#input\_app\_installation\_id)

Description: (Required) ID of the GitHub App installation used to authenticate.

Type: `string`

### <a name="input_app_pem_file"></a> [app\_pem\_file](#input\_app\_pem\_file)

Description: (Required) Content of the GitHub App private key PEM file used to authenticate.

Type: `string`

### <a name="input_github_organization"></a> [github\_organization](#input\_github\_organization)

Description: (Required) The target GitHub organization or individual user account to manage.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_github_teams"></a> [github\_teams](#input\_github\_teams)

Description:   (Optional) The github\_teams block supports the following:  
    name        : (Required) The name of the team.  
    description : (Optional) A description of the team.  
    permission  : (Optional) The permissions of team members regarding the repository. Must be one of `pull`, `triage`, `push`, `maintain`, `admin` or the name of an existing custom repository role within the organisation.

Type:

```hcl
list(object({
    name        = string
    description = optional(string)
    permission  = optional(string, "pull")
  }))
```

Default:

```json
[
  {
    "description": "This group grant admin access to the Terraform Modules repository.",
    "name": "Terraform-Modules-Owners",
    "permission": "admin"
  },
  {
    "description": "This group grant write access to the Terraform Modules repository.",
    "name": "Terraform-Modules-Contributors",
    "permission": "push"
  }
]
```

### <a name="input_github_template"></a> [github\_template](#input\_github\_template)

Description: (Optional) The GitHub repository to use as a template when creating new repositories. The repository must be a template repository. If not provided, the default template provided by the module will be used.

Type: `string`

Default: `null`

### <a name="input_module_name"></a> [module\_name](#input\_module\_name)

Description: (Optional) Name of the terraform module used by the modules factory.

Type: `string`

Default: `"terraform-tfe-modulesfactory"`

### <a name="input_oauth_client_name"></a> [oauth\_client\_name](#input\_oauth\_client\_name)

Description: (Optional) Name of the OAuth client.

Type: `string`

Default: `"GitHub"`

### <a name="input_organization"></a> [organization](#input\_organization)

Description: (Optional) A description for the project.

Type: `string`

Default: `"benoitblais-hashicorp"`

### <a name="input_project_description"></a> [project\_description](#input\_project\_description)

Description: (Optional) A description for the project.

Type: `string`

Default: `null`

### <a name="input_project_name"></a> [project\_name](#input\_project\_name)

Description: (Optional) Name of the project.

Type: `string`

Default: `"Terraform Modules Factory"`

### <a name="input_project_tags"></a> [project\_tags](#input\_project\_tags)

Description: (Optional) A map of key-value tags to add to the project.

Type: `map(string)`

Default: `null`

## Resources

The following resources are used by this module:

- [github_actions_secret.tfe_token](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_secret) (resource)
- [tfe_no_code_module.this](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/no_code_module) (resource)
- [tfe_project.this](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/project) (resource)
- [tfe_registry_module.this](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/registry_module) (resource)
- [tfe_test_variable.github_app_id](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/test_variable) (resource)
- [tfe_test_variable.github_app_installation_id](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/test_variable) (resource)
- [tfe_test_variable.github_app_pem_file](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/test_variable) (resource)
- [tfe_test_variable.github_owner](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/test_variable) (resource)
- [tfe_test_variable.oauth_client_name](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/test_variable) (resource)
- [tfe_test_variable.organization](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/test_variable) (resource)
- [tfe_test_variable.tfe_token](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/test_variable) (resource)
- [tfe_variable.git_tfe_token](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable) (resource)
- [tfe_variable.github_app_id](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable) (resource)
- [tfe_variable.github_app_installation_id](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable) (resource)
- [tfe_variable.github_app_pem_file](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable) (resource)
- [tfe_variable.github_owner](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable) (resource)
- [tfe_variable.github_teams](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable) (resource)
- [tfe_variable.oauth_client_name](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable) (resource)
- [tfe_variable.organization](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable) (resource)
- [tfe_variable.template](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable) (resource)
- [tfe_variable.tfe_token](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable) (resource)
- [tfe_variable_set.this](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable_set) (resource)
- [tfe_oauth_client.client](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/data-sources/oauth_client) (data source)

## Outputs

No outputs.

<!-- markdownlint-enable -->
<!-- END_TF_DOCS -->
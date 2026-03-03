<!-- BEGIN_TF_DOCS -->
# HCP Terraform Modules Registry Factory

Code which manages configuration and life-cycle of all the HCP Terraform
private registry factory. It is designed to be used from a dedicated
API-Driven HCP Terraform workspace that would provision and manage the
configuration using Terraform code (IaC).

> Module publication to the private registry is facilitated through a no-code
> module. Each no-code module must be provisioned within the dedicated project
> to ensure proper variable input configuration and management.

## Permissions

### HCP Terraform Permissions

To manage the resources, provide a user token from an account with
appropriate permissions. This user should have the `Manage Modules`, `Manage Projects`,
`Manage Workspaces`, `Manage Teams`, `Manage Membership`, and `Manage Organization Access`
permission. Alternatively, you can use a token from a team instead of a user token.

### GitHub Permissions

To manage the GitHub resources, provide a token from an account or a GitHub App with
appropriate permissions. It should have:

* Read access to `metadata`
* Read and write access to `administration`, `code`, `secrets`, and `members`.

## Authentication

### HCP Terraform Authentication

The HCP Terraform provider requires a HCP Terraform/Terraform Enterprise API token in
order to manage resources.

There are several ways to provide the required token:

* Set the `token` argument in the provider configuration. You can set the token argument in the provider configuration. Use an
input variable for the token.
* Set the `TFE_TOKEN` environment variable. The provider can read the TFE\\_TOKEN environment variable and the token stored there
to authenticate.

### GitHub Authentication

The GitHub provider requires a GitHub token or GitHub App installation in order to manage resources.

There are several ways to provide the required token:

* Set the `token` argument in the provider configuration. You can set the `token` argument in the provider configuration. Use an
input variable for the token.
* Set the `GITHUB_TOKEN` environment variable. The provider can read the `GITHUB_TOKEN` environment variable and the token stored there
to authenticate.

There are several ways to provide the required GitHub App installation:

* Set the `app_auth` argument in the provider configuration. You can set the app\\_auth argument with the id, installation\\_id and pem\\_file
in the provider configuration. The owner parameter is also required in this situation.
* Set the `GITHUB_APP_ID`, `GITHUB_APP_INSTALLATION_ID` and `GITHUB_APP_PEM_FILE` environment variables. The provider can read the GITHUB\\_APP\\_ID,
GITHUB\\_APP\\_INSTALLATION\\_ID and GITHUB\\_APP\\_PEM\\_FILE environment variables to authenticate.

> Because strings with new lines is not support:</br>
> use "\\\n" within the `pem_file` argument to replace new line</br>
> use "\n" within the `GITHUB_APP_PEM_FILE` environment variables to replace new line</br>

## Features

* Manages configuration and life-cycle of GitHub resources for Terraform no-code module repository:
  * Repository
  * Branch protection
  * Teams
  * Secret
* Manages configuration and life-cycle of HCP Terraform resources:
  * Project
  * Variable Set
    * Variables
  * Teams
    * Team token
  * Private module registry
    * No-code feature
  * Private module registry test environment variable

## Documentation

## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.13.0)

- <a name="requirement_github"></a> [github](#requirement\_github) (~> 6.8.0)

- <a name="requirement_tfe"></a> [tfe](#requirement\_tfe) (~> 0.72)

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

### <a name="input_organization_name"></a> [organization\_name](#input\_organization\_name)

Description: (Required) Name of the organization.

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
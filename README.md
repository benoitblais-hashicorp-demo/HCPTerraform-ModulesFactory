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

### Azure DevOps Permissions

To manage the Azure DevOps resources, provide a Personal Access Token (PAT)
from an account with appropriate permissions. The PAT should have:

* **Code**: Read, Create & Manage

## Authentication

### HCP Terraform Authentication

The HCP Terraform provider requires a HCP Terraform/Terraform Enterprise API token in
order to manage resources.

There are several ways to provide the required token:

* Set the `TFE_TOKEN` environment variable. The provider can read the `TFE_TOKEN` environment variable and the token stored there to authenticate.

### Azure DevOps Authentication

The Azure DevOps provider requires either a Personal Access Token or a Service Principal
in order to manage resources.

There are several ways to provide the required credentials:

* Set the `AZDO_PERSONAL_ACCESS_TOKEN` environment variable.
* Set the `AZDO_ORG_SERVICE_URL` environment variable (e.g. `https://dev.azure.com/myorg`).

## Features

* Manages configuration and life-cycle of Azure DevOps resources for Terraform no-code module repository:
  * Repository
  * Branch policies (minimum reviewers, comment resolution, merge types, auto reviewers)
* Manages configuration and life-cycle of HCP Terraform resources:
  * Project
  * Variable Set
    * Variables
  * Private module registry
    * No-code feature
  * Private module registry test environment variables

## Documentation

## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.13.0)

- <a name="requirement_azuredevops"></a> [azuredevops](#requirement\_azuredevops) (~> 1.16)

- <a name="requirement_tfe"></a> [tfe](#requirement\_tfe) (~> 0.79)

## Modules

The following Modules are called:

### <a name="module_modules_factory_repository"></a> [modules\_factory\_repository](#module\_modules\_factory\_repository)

Source: ./modules/azuredevops_repository

Version:

## Required Inputs

The following input variables are required:

### <a name="input_azdo_org_name"></a> [azdo\_org\_name](#input\_azdo\_org\_name)

Description: (Required) The short name (slug) of the Azure DevOps organization as it appears in the org URL (e.g. "myorg" for https://dev.azure.com/myorg). Used to construct VCS identifiers.

Type: `string`

### <a name="input_azdo_org_service_url"></a> [azdo\_org\_service\_url](#input\_azdo\_org\_service\_url)

Description: (Required) The URL of the Azure DevOps organization (e.g. https://dev.azure.com/myorg). Can also be set via the AZDO_ORG_SERVICE_URL environment variable.

Type: `string`

### <a name="input_azdo_personal_access_token"></a> [azdo\_personal\_access\_token](#input\_azdo\_personal\_access\_token)

Description: (Required) The Azure DevOps Personal Access Token used to authenticate. Can also be set via the AZDO_PERSONAL_ACCESS_TOKEN environment variable.

Type: `string`

### <a name="input_azdo_project_id"></a> [azdo\_project\_id](#input\_azdo\_project\_id)

Description: (Required) The ID of the Azure DevOps project where the factory repository will be created.

Type: `string`

### <a name="input_azdo_project_name"></a> [azdo\_project\_name](#input\_azdo\_project\_name)

Description: (Required) The name of the Azure DevOps project where repositories will be created by the no-code module workspaces.

Type: `string`

### <a name="input_organization_name"></a> [organization\_name](#input\_organization\_name)

Description: (Required) Name of the HCP Terraform organization.

Type: `string`

### <a name="input_tfe_token"></a> [tfe\_token](#input\_tfe\_token)

Description: (Required) HCP Terraform API token used by child workspaces to publish modules into the private registry.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_module_name"></a> [module\_name](#input\_module\_name)

Description: (Optional) Name of the terraform module used by the modules factory.

Type: `string`

Default: `"terraform-azuredevops-modulesfactory"`

### <a name="input_oauth_client_name"></a> [oauth\_client\_name](#input\_oauth\_client\_name)

Description: (Optional) Name of the OAuth client used to connect HCP Terraform to the Azure DevOps VCS provider.

Type: `string`

Default: `"AzureDevOps"`

### <a name="input_project_description"></a> [project\_description](#input\_project\_description)

Description: (Optional) A description for the project.

Type: `string`

Default: `null`

### <a name="input_project_name"></a> [project\_name](#input\_project\_name)

Description: (Optional) Name of the HCP Terraform project.

Type: `string`

Default: `"Terraform Modules Factory"`

### <a name="input_project_tags"></a> [project\_tags](#input\_project\_tags)

Description: (Optional) A map of key-value tags to add to the project.

Type: `map(string)`

Default: `null`

## Resources

The following resources are used by this module:

- [tfe_no_code_module.this](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/no_code_module) (resource)
- [tfe_project.this](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/project) (resource)
- [tfe_registry_module.this](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/registry_module) (resource)
- [tfe_test_variable.azdo_org_service_url](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/test_variable) (resource)
- [tfe_test_variable.azdo_personal_access_token](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/test_variable) (resource)
- [tfe_test_variable.azdo_project_name](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/test_variable) (resource)
- [tfe_test_variable.oauth_client_name](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/test_variable) (resource)
- [tfe_test_variable.organization](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/test_variable) (resource)
- [tfe_test_variable.tfe_token](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/test_variable) (resource)
- [tfe_variable.azdo_org_service_url](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable) (resource)
- [tfe_variable.azdo_personal_access_token](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable) (resource)
- [tfe_variable.azdo_project_name](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable) (resource)
- [tfe_variable.oauth_client_name](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable) (resource)
- [tfe_variable.organization](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable) (resource)
- [tfe_variable.tfe_token](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable) (resource)
- [tfe_variable_set.this](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable_set) (resource)
- [tfe_oauth_client.client](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/data-sources/oauth_client) (data source)

## Outputs

No outputs.

<!-- markdownlint-enable -->
<!-- END_TF_DOCS -->

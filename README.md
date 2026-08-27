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
  * Variable Set (with variables for child workspaces)
  * Private module registry
    * No-code feature
  * Private module registry test variables (for `terraform test` runs in HCP Terraform)

## Testing

The module enables `terraform test` on the published private registry module. When tests run
inside HCP Terraform, all required variables are injected automatically by the
`tfe_test_variable` resources provisioned by this module.

For **local** execution, export the following environment variables before running
`terraform test`:

```powershell
# Provider credentials — read directly by the providers (no TF_VAR_ prefix)
$env:AZDO_ORG_SERVICE_URL                     = "https://dev.azure.com/<azuredevops_organization>"
$env:AZDO_PERSONAL_ACCESS_TOKEN               = "<pat>"
$env:TFE_TOKEN                                = "<hcp_terraform_token>"

# Terraform module variables (consumed by the module under test)
$env:TF_VAR_azuredevops_organization          = "<azuredevops_organization>"
$env:TF_VAR_azuredevops_personal_access_token = "<pat>"
$env:TF_VAR_azdo_project_name                 = "<azure_devops_project_name>"
$env:TF_VAR_organization                      = "<hcp_terraform_organization>"
$env:TF_VAR_oauth_client_name                 = "Azure DevOps Services"

terraform test
```

> `AZDO_PERSONAL_ACCESS_TOKEN` and `TF_VAR_azuredevops_personal_access_token` can point to
> the same PAT value. `TFE_TOKEN` is read directly by the `tfe` provider and does not need
> a `TF_VAR_` counterpart for tests.

## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.13.0)

- <a name="requirement_azuredevops"></a> [azuredevops](#requirement\_azuredevops) (~> 1.16)

- <a name="requirement_tfe"></a> [tfe](#requirement\_tfe) (~> 0.79)

## Modules

The following Modules are called:

### <a name="module_modules_factory_repository"></a> [modules\_factory\_repository](#module\_modules\_factory\_repository)

Source: `./modules/azuredevops_repository`

## Required Inputs

The following input variables are required:

### <a name="input_azuredevops_organization"></a> [azuredevops\_organization](#input\_azuredevops\_organization)

Description: (Required) The name of the Azure DevOps organization (the segment after `dev.azure.com/` in the URL). Used to build the VCS identifier for HCP Terraform workspaces.

Type: `string`

### <a name="input_azuredevops_personal_access_token"></a> [azuredevops\_personal\_access\_token](#input\_azuredevops\_personal\_access\_token)

Description: (Required) The Azure DevOps Personal Access Token used to authenticate. Can also be set via the `AZDO_PERSONAL_ACCESS_TOKEN` environment variable.

Type: `string`

### <a name="input_azuredevops_project_name"></a> [azuredevops\_project\_name](#input\_azuredevops\_project\_name)

Description: (Required) The name of the Azure DevOps project in which all factory repositories will be created. Used to look up the project UUID at plan time.

Type: `string`

### <a name="input_organization_name"></a> [organization\_name](#input\_organization\_name)

Description: (Required) Name of the HCP Terraform organization.

Type: `string`

### <a name="input_tfe_token"></a> [tfe\_token](#input\_tfe\_token)

Description: (Required) HCP Terraform API token used by child workspaces to publish modules into the private registry.

Type: `string`

### <a name="input_vcs_oauth_token_id"></a> [vcs\_oauth\_token\_id](#input\_vcs\_oauth\_token\_id)

Description: (Required) The OAuth Token ID of the HCP Terraform VCS Provider connection to use for VCS-driven workspaces. Find it in the HCP Terraform UI: Organization Settings → VCS Providers → click the connection → the value starts with `ot-` (not `oc-`).

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_azuredevops_service_url"></a> [azuredevops\_service\_url](#input\_azuredevops\_service\_url)

Description: (Optional) The base URL of the Azure DevOps service. Defaults to `https://dev.azure.com`. The full organization URL is constructed automatically as `<azuredevops_service_url>/<azuredevops_organization>`.

Type: `string`

Default: `"https://dev.azure.com"`

### <a name="input_module_name"></a> [module\_name](#input\_module\_name)

Description: (Optional) Name of the Terraform module used by the modules factory. Must follow the convention `terraform-<provider>-<name>`.

Type: `string`

Default: `"terraform-tfe-modulesfactory"`

### <a name="input_module_provider"></a> [module\_provider](#input\_module\_provider)

Description: (Optional) The main provider the module uses (e.g., `tfe`, `azurerm`, `aws`). Derived automatically from `module_name` by extracting the middle segment of the `terraform-<provider>-<name>` convention.

Type: `string`

Default: `"tfe"`

### <a name="input_oauth_client_name"></a> [oauth\_client\_name](#input\_oauth\_client\_name)

Description: (Optional) Display name of the HCP Terraform VCS OAuth client (Azure DevOps VCS provider connection). Defaults to `Azure DevOps Services`, which is the name assigned by HCP Terraform when the connection is created through the UI.

Type: `string`

Default: `"Azure DevOps Services"`

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
- [tfe_test_variable.azdo_org_service_url](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/test_variable) (resource) — injects `AZDO_ORG_SERVICE_URL`
- [tfe_test_variable.azdo_personal_access_token](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/test_variable) (resource) — injects `AZDO_PERSONAL_ACCESS_TOKEN`
- [tfe_test_variable.azdo_organization](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/test_variable) (resource) — injects `TF_VAR_azuredevops_organization`
- [tfe_test_variable.azdo_project_name](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/test_variable) (resource) — injects `TF_VAR_azdo_project_name`
- [tfe_test_variable.azdo_personal_access_token_var](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/test_variable) (resource) — injects `TF_VAR_azuredevops_personal_access_token`
- [tfe_test_variable.oauth_client_name](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/test_variable) (resource) — injects `TF_VAR_oauth_client_name`
- [tfe_test_variable.organization](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/test_variable) (resource) — injects `TF_VAR_organization`
- [tfe_test_variable.module_name](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/test_variable) (resource) — injects `TF_VAR_module_name`
- [tfe_test_variable.module_provider](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/test_variable) (resource) — injects `TF_VAR_module_provider`
- [tfe_test_variable.tfe_token](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/test_variable) (resource) — injects `TFE_TOKEN`
- [tfe_variable.azdo_org_service_url](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable) (resource)
- [tfe_variable.azdo_personal_access_token](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable) (resource)
- [tfe_variable.azdo_project_name](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable) (resource)
- [tfe_variable.module_name](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable) (resource)
- [tfe_variable.module_provider](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable) (resource)
- [tfe_variable.oauth_client_name](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable) (resource)
- [tfe_variable.organization](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable) (resource)
- [tfe_variable.tfe_token](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable) (resource)
- [tfe_variable_set.this](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable_set) (resource)
- [azuredevops_project.this](https://registry.terraform.io/providers/microsoft/azuredevops/latest/docs/data-sources/project) (data source)

## Outputs

No outputs.

<!-- markdownlint-enable -->
<!-- END_TF_DOCS -->

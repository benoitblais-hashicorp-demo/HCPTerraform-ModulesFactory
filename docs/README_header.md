# HCP Terraform Modules Registry Factory

Code which manages configuration and life-cycle of all the HCP Terraform
private registry factory. It is designed to be used from a dedicated
API-Driven HCP Terraform workspace that would provision and manage the
configuration using Terraform code (IaC).

> Module publication to the private registry is facilitated through a no-code 
> module workflow that creates and configures the required GitHub repository 
> and publishes the initial module version to the private registry. Each no-code 
> module must be provisioned within the dedicated project to ensure proper 
> variable input configuration and management.

## Permissions

### HCP Terraform Permissions

To manage the agent pool resources, provide a user token from an account with
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
* Set the `TFE_TOKEN` environment variable. The provider can read the TFE\_TOKEN environment variable and the token stored there
to authenticate.

### GitHub Authentication

The GitHub provider requires a GitHub token or GitHub App installation in order to manage resources.

There are several ways to provide the required token:

* Set the `token` argument in the provider configuration. You can set the `token` argument in the provider configuration. Use an
input variable for the token.
* Set the `GITHUB_TOKEN` environment variable. The provider can read the `GITHUB_TOKEN` environment variable and the token stored there
to authenticate.

There are several ways to provide the required GitHub App installation:

* Set the `app_auth` argument in the provider configuration. You can set the app\_auth argument with the id, installation\_id and pem\_file
in the provider configuration. The owner parameter is also required in this situation.
* Set the `GITHUB_APP_ID`, `GITHUB_APP_INSTALLATION_ID` and `GITHUB_APP_PEM_FILE` environment variables. The provider can read the GITHUB\_APP\_ID,
GITHUB\_APP\_INSTALLATION\_ID and GITHUB\_APP\_PEM\_FILE environment variables to authenticate.

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

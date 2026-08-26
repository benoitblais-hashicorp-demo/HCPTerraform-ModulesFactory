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

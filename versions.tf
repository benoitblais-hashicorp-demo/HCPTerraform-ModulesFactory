terraform {

  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = "~>0.70"
    }
    github = {
      source  = "integrations/github"
      version = "~> 6.8.0"
    }
  }

  required_version = ">= 1.13.0"

}
terraform {

  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = "~> 0.72"
    }
  }

  required_version = ">= 1.13.0"

}

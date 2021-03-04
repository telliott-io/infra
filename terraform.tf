terraform {
  required_version = "0.13.6"

  backend "remote" {
      organization = "telliott-io"
      workspaces {
          name = "infra"
      }
  }

  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "2.5.1"
    }
    tfe = {
      source = "hashicorp/tfe"
      version = "0.24.0"
    }
  }
}
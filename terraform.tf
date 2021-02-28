terraform {
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
  }
}
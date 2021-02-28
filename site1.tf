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

module "cluster" {
  source   = "github.com/telliott-io/kube-clusters//digitalocean?ref=v0.6.1"
  cluster_name = "site1"
}

provider "digitalocean" {
  token = var.do_token
}

variable "do_token" {}

module "platform" {
  source = "github.com/telliott-io/platform?ref=v0.6.0"
	kubernetes = jsonencode(module.cluster.kubernetes)
	environment = "platform-test"
	hostname = "platform.test"
	argocd_admin_password = "secret"
	bootstrap_repository = "https://telliott-io.github.io/testbootstrap"
	bootstrap_chart = "bootstrap"
	bootstrap_version = "0.1.1"
	dns_name = var.dns_name
}

variable dns_name {
	default = null
}
terraform {
  extra_arguments "common_vars" {
    commands = ["plan", "apply", "destroy"]

    optional_var_files = [
      "${get_terragrunt_dir()}/${path_relative_from_include()}/terraform.tfvars",
    ]
  }
}

generate "cloudflare-provider" {
  path = "cloudflare-provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
# Configure the Cloudflare provider
provider "cloudflare" {
  version = "~> 2.0"
  email   = var.cloudflare_email
  api_key = var.cloudflare_api_key
}

variable cloudflare_email {}
variable cloudflare_api_key {}
EOF
}

generate "gke-provider" {
  path = "gke-provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
provider "google" {
  credentials = base64decode(var.gcloud_credentials_base64)
  project     = "telliott-io"
  region      = "us-central1"
  zone        = "us-central1-c"
}

variable "gcloud_credentials_base64" {}
EOF
}

generate "do-provider" {
  path = "do-provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
# Configure the DigitalOcean Provider
provider "digitalocean" {
  token = var.do_token
}

variable "do_token" {}
EOF
}

remote_state {
  backend = "gcs"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket  = "telliott-io-tf-state"
    prefix  =  "terragrunt/${path_relative_to_include()}"
    credentials = "${find_in_parent_folders("gcloud-credentials.json")}"
  }
}
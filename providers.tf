provider "digitalocean" {
  token = var.do_token
}

provider "tfe" {
  # Configuration options
  token = var.tf_token
}

module "ingress" {
  source   = "../../modules/ingress/nginx"
}

module "cd" {
  source   = "../cd/argocd"
  argocd_admin_password = var.argocd_admin_password
}

module "secrets" {
  source = "../secrets"
  signing_cert = var.secret_signing_cert
  signing_key = var.secret_signing_key
}

module "environment" {
  source = "../envserver"
  environment_data = {
    environment = var.environment
  }
  hostname = var.hostname
}
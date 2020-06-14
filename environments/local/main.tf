#####################################################################
# Providers
#####################################################################
provider "kubernetes" {
  load_config_file = true
}

provider "helm" {
  kubernetes {
    load_config_file = true
  }
}

#####################################################################
# Modules
#####################################################################

module "ingress" {
  source   = "../../modules/ingress/nginx"
  load_balancer_ip = "127.0.0.1"
}

module "cd" {
  source = "../../modules/cd/argocd"
  # Password is 'password'
  argocd_admin_password = "$2y$10$z26ZOTDMaIzxBMl9PLNGF.lNccsGWpY5bKymL.PF2UkIdN4nIelbG"
}

module "secrets" {
  source = "../../modules/secrets"
  signing_cert = var.secret_signing_cert
  signing_key = var.secret_signing_key
}

module "environment" {
  source = "../../modules/envserver"
  environment_data = {
    environment = "local"
  }
}

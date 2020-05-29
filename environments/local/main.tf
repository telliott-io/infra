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
  source   = "../../ingress/nginx"
  load_balancer_ip = "127.0.0.1"
}

module "cd" {
  source = "../../cd/argocd"
  # Password is 'password'
  argocd_admin_password = "$2y$10$z26ZOTDMaIzxBMl9PLNGF.lNccsGWpY5bKymL.PF2UkIdN4nIelbG"
}

module "secrets" {
  source = "../../secrets"
  signing_cert = var.secret_signing_cert
  signing_key = var.secret_signing_key
}

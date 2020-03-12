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
module "monitoring" {
  source   = "../../monitoring"
}

module "ingress" {
  source   = "../../ingress/nginx"
  load_balancer_ip = "127.0.0.1"
}

module "cd" {
  source   = "../../cd/argocd"
}
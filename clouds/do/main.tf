module "cluster" {
  source   = "github.com/telliott-io/kube-clusters//digitalocean"
  cluster_name = var.cluster_name
}

variable cluster_name {}

provider "kubernetes" {
    load_config_file = false
    host     = module.cluster.kubernetes.host
    username = module.cluster.kubernetes.username
    password = module.cluster.kubernetes.password
    cluster_ca_certificate = module.cluster.kubernetes.cluster_ca_certificate
    token = module.cluster.kubernetes.token
}

provider "helm" {
  kubernetes {
    load_config_file = false
    host     = module.cluster.kubernetes.host
    username = module.cluster.kubernetes.username
    password = module.cluster.kubernetes.password
    cluster_ca_certificate = module.cluster.kubernetes.cluster_ca_certificate
    token = module.cluster.kubernetes.token
  }
}

module "ingress" {
  source   = "../../modules/ingress/nginx"
}

output "ingress_address" {
    value = "${module.ingress.external_ip}"
}

variable argocd_admin_password {}

module "cd" {
  source   = "../../modules/cd/argocd"
  argocd_admin_password = var.argocd_admin_password
}

module "secrets" {
  source = "../../modules/secrets"
  signing_cert = var.secret_signing_cert
  signing_key = var.secret_signing_key
}

# Keypair for use with sealed secrets
variable secret_signing_cert {}
variable secret_signing_key {}

module "environment" {
  source = "../../modules/envserver"
  environment_data = {
    environment = "digitalocean"
  }
}

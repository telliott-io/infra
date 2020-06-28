
provider "kubernetes" {
    load_config_file = false
    host     = jsondecode(var.config).host
    username = jsondecode(var.config).username
    password = jsondecode(var.config).password
    cluster_ca_certificate = jsondecode(var.config).cluster_ca_certificate
    token = jsondecode(var.config).token
}

provider "helm" {
  kubernetes {
    load_config_file = false
    host     = jsondecode(var.config).host
    username = jsondecode(var.config).username
    password = jsondecode(var.config).password
    cluster_ca_certificate = jsondecode(var.config).cluster_ca_certificate
    token = jsondecode(var.config).token
  }
}

module "config" {
    source = "../../../modules/configuration"
    hostname = var.hostname
    environment = "digitalocean-prod-primary"
    argocd_admin_password = var.argocd_admin_password
    secret_signing_cert = var.secret_signing_cert
    secret_signing_key = var.secret_signing_key
}

variable hostname {}

variable argocd_admin_password {}
# Keypair for use with sealed secrets
variable secret_signing_cert {}
variable secret_signing_key {}

variable config {}

output "ingress_address" {
    value = module.config.ingress_address
}
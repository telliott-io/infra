#####################################################################
# Modules
#####################################################################

module "do" {
  source   = "./environments/do"
  argocd_admin_password = var.argocd_admin_password
}

module "dns" {
  source = "./dns"
  cloudflare_zone_id = "${var.cloudflare_zone_id}"
  ingress_ip = module.do.ingress_address
  domain = "telliott.io"
}

module "secrets" {
  source = "./secrets"
  signing_cert = var.secret_signing_cert
  signing_key = var.secret_signing_key
}
#####################################################################
# Variables
#####################################################################
variable cloudflare_email {}
variable cloudflare_api_key {}
variable cloudflare_zone_id {}
variable "do_token" {} # Digital Ocean auth token

# Initial admin password for ArgoCD
# bcrypt hashed:
# $ htpasswd -nbBC 10 "" "secret"  | tr -d ':\n'
variable argocd_admin_password {}

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
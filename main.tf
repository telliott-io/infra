#####################################################################
# Variables
#####################################################################
variable cloudflare_email {}
variable cloudflare_api_key {}
variable cloudflare_zone_id {}
variable "do_token" {} # Digital Ocean auth token

#####################################################################
# Modules
#####################################################################

module "do" {
  source   = "./environments/do"
}

module "dns" {
  source = "./dns"
  cloudflare_zone_id = "${var.cloudflare_zone_id}"
  ingress_ips = [
    module.do.ingress_address,
  ]
  domain = "telliott.io"
}
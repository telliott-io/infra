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
module "gke" {
  source   = "./gke"
}

module "do" {
  source   = "./environments/do"
}

module "dns" {
  source = "./dns"
  cloudflare_zone_id = "${var.cloudflare_zone_id}"
  ingress_ips = [
    module.gke.ingress_address,
    module.do.ingress_address,
  ]
  domain = "telliott.io"
}

module "ingress" {
  source   = "./ingress/nginx"
  load_balancer_ip = "${module.gke.ingress_address}"
}

module "monitoring" {
  source   = "./monitoring"
}
#####################################################################
# Variables
#####################################################################
variable cloudflare_email {}
variable cloudflare_api_key {}
variable cloudflare_zone_id {}

#####################################################################
# Modules
#####################################################################
module "gke" {
  source   = "./gke"
}

module "dns" {
  source = "./dns"
  cloudflare_zone_id = "${var.cloudflare_zone_id}"
  ingress_address = "${module.gke.ingress_address}"
}

module "ingress" {
  source   = "./ingress/nginx"
  load_balancer_ip = "${module.gke.ingress_address}"
}

module "monitoring" {
  source   = "./monitoring"
}
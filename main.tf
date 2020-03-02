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
  source   = "./do"
}

module "dns" {
  source = "./dns"
  cloudflare_zone_id = "${var.cloudflare_zone_id}"
  ingress_address = "${module.gke.ingress_address}"
  do_ingress_address = "${module.do.ingress_address}"
  traefik_ingress_address = "${module.gke.traefik_ingress_address}"
  domain = "telliott.io"
}

module "ingress" {
  source   = "./ingress/nginx"
  load_balancer_ip = "${module.gke.ingress_address}"
}

module "ingress_traefik" {
  source   = "./ingress/traefik"
  load_balancer_ip = "${module.gke.traefik_ingress_address}"
}


module "monitoring" {
  source   = "./monitoring"
}
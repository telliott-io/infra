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

  cloudflare_email   = "${var.cloudflare_email}"
  cloudflare_api_key = "${var.cloudflare_api_key}"
  cloudflare_zone_id = "${var.cloudflare_zone_id}"
  ingress_address = "${module.gke.ingress_address}"
}

module "ingress" {
  source   = "./ingress/nginx"
  host     = "${module.gke.host}"

  cluster_ca_certificate = "${module.gke.cluster_ca_certificate}"

  load_balancer_ip = "${module.gke.ingress_address}"
}

module "monitoring" {
  source   = "./monitoring"
  host     = "${module.gke.host}"
  cluster_ca_certificate = "${module.gke.cluster_ca_certificate}"
}
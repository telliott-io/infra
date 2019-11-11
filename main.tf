#####################################################################
# Modules
#####################################################################
module "gke" {
  source   = "./gke"
}

module "ingress" {
  source   = "./ingress/nginx"
  host     = "${module.gke.host}"

  cluster_ca_certificate = "${module.gke.cluster_ca_certificate}"
}
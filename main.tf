#####################################################################
# Variables
#####################################################################
variable token {
  description = "OAuth token for Google Cloud user. Can be obtained with `gcloud auth application-default print-access-token`"
}

#####################################################################
# Modules
#####################################################################
module "gke" {
  source   = "./gke"

  token = "${var.token}"
}

module "ingress" {
  source   = "./ingress/nginx"
  host     = "${module.gke.host}"

  cluster_ca_certificate = "${module.gke.cluster_ca_certificate}"

  token = "${var.token}"
}
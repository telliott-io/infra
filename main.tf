# Based on https://medium.com/@Joachim8675309/deploy-kubernetes-apps-with-terraform-5b74e5891958

variable "username" {
  default = "admin"
}
variable "password" {}

#####################################################################
# Modules
#####################################################################
module "gke" {
  source   = "./gke"
  username = "${var.username}"
  password = "${var.password}"
}

# module "ingress" {
#   source   = "./ingress/nginx"
#   host     = "${module.gke.host}"

#   client_certificate     = "${module.gke.client_certificate}"
#   client_key             = "${module.gke.client_key}"
#   cluster_ca_certificate = "${module.gke.cluster_ca_certificate}"
#   username = "${var.username}"
#   password = "${var.password}"
# }

# module "k8s" {
#   source   = "./k8s"
#   host     = "${module.gke.host}"

#   client_certificate     = "${module.gke.client_certificate}"
#   client_key             = "${module.gke.client_key}"
#   cluster_ca_certificate = "${module.gke.cluster_ca_certificate}"
#   username = "${var.username}"
#   password = "${var.password}"
# }
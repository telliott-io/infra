module "do" {
  source   = "../../do"
}

provider "kubernetes" {
  load_config_file = false
  host     = "${module.do.host}"

  cluster_ca_certificate = "${module.do.cluster_ca_certificate}"
  token = "${module.do.token}"
}

module "ingress" {
  source   = "../../ingress/nginx"
  load_balancer_ip = "${module.do.ingress_address}"
}

module "monitoring" {
  source   = "../../monitoring"
}

output "ingress_address" {
    value = "${module.do.ingress_address}"
}
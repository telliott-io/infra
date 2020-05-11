module "do" {
  source   = "../../kubernetes/do"
  name = "primary"
}

provider "kubernetes" {
  load_config_file = false
  host     = "${module.do.host}"

  cluster_ca_certificate = "${module.do.cluster_ca_certificate}"
  token = "${module.do.token}"
}

provider "helm" {
  kubernetes {
    load_config_file = false
    host     = "${module.do.host}"
    cluster_ca_certificate = "${module.do.cluster_ca_certificate}"
    token = "${module.do.token}"
  }
}
module "ingress" {
  source   = "../../ingress/nginx"
}

output "ingress_address" {
    value = "${module.ingress.external_ip}"
}

variable argocd_admin_password {}

module "cd" {
  source   = "../../cd/argocd"
  argocd_admin_password = var.argocd_admin_password
}
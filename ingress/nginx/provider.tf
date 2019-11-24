provider "kubernetes" {
  load_config_file = false
  host     = "${var.host}"

  cluster_ca_certificate = "${base64decode(var.cluster_ca_certificate)}"
  token = "${var.token}"
}
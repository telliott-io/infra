resource "kubernetes_config_map" "grafana_config" {
  metadata {
    name = "grafana-config"
    namespace = "monitoring"
  }

  data = {
    "datasource.yaml" = "${file("${path.module}/datasource.yaml")}"
  }
}


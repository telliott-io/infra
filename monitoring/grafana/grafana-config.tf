resource "kubernetes_config_map" "grafana_config" {
  depends_on = [null_resource.module_depends_on]

  metadata {
    name = "grafana-config"
    namespace = "monitoring"
  }

  data = {
    "datasource.yaml" = "${file("${path.module}/datasource.yaml")}"
  }
}


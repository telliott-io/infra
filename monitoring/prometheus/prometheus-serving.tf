resource "kubernetes_service" "prometheus_service" {
  depends_on = [null_resource.module_depends_on]

  metadata {
    name      = "prometheus-service"
    namespace = "monitoring"

    annotations = {
      "prometheus.io/port" = "9090"

      "prometheus.io/scrape" = "true"
    }
  }

  spec {
    type = "NodePort"

    port {
      name = "http"
      port        = 8080
      target_port = "9090"
    }

    selector = {
      app = "prometheus-server"
    }
  }
}


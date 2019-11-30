resource "kubernetes_service" "prometheus_service" {
  metadata {
    name      = "prometheus-service"
    namespace = "monitoring"

    annotations = {
      "prometheus.io/port" = "9090"

      "prometheus.io/scrape" = "true"
    }
  }

  spec {
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


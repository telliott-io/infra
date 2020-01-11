resource "kubernetes_ingress" "prometheus" {
  metadata {
    name = "prometheus"
    namespace = "monitoring"
    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
    }
  }

  spec {
    rule {
      host = "prometheus.telliott.io"

      http {
        path {
          path = "/"

          backend {
            service_name = "prometheus-service"
            service_port = "http"
          }
        }
      }
    }
  }
}


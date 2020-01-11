resource "kubernetes_ingress" "grafana" {
  metadata {
    name = "grafana"
    namespace = "monitoring"
    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
    }
  }

  spec {
    rule {
      host = "grafana.telliott.io"

      http {
        path {
          path = "/"

          backend {
            service_name = "grafana"
            service_port = "3000"
          }
        }
      }
    }
  }
}


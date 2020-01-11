resource "kubernetes_ingress" "jaeger" {
  metadata {
    name = "jaeger"
    namespace = "monitoring"
    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
    }
  }

  spec {
    rule {
      host = "jaeger.telliott.io"

      http {
        path {
          path = "/"

          backend {
            service_name = "jaeger-query"
            service_port = "query-http"
          }
        }
      }
    }
  }
}


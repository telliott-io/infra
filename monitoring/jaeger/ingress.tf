resource "kubernetes_ingress" "jaeger" {
  metadata {
    name = "jaeger"
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


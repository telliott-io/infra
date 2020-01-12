resource "kubernetes_ingress" "jaeger" {
  metadata {
    name = "jaeger"
    namespace = "monitoring"
    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "jaeger.*"
    }
  }

  spec {
    rule {
      host = "jaeger"

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


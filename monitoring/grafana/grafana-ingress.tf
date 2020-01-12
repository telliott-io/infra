resource "kubernetes_ingress" "grafana" {
  metadata {
    name = "grafana"
    namespace = "monitoring"
    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "grafana.*"
    }
  }

  spec {
    rule {
      host = "grafana"

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


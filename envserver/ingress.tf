resource "kubernetes_ingress" "envserver" {
  depends_on = [
    kubernetes_deployment.envserver,
  ]

  metadata {
    name      = "envserver"
    namespace = "environment"
  }

  spec {
    rule {
      host = "telliott.io"
      http {
        path {
          path = "/environment"

          backend {
            service_name = "envserver"
            service_port = "http"
          }
        }
      }
    }
  }
}

resource "kubernetes_ingress" "traefikadmin" {
  metadata {
    name = "traefik-admin"
    namespace = "traefik"
    annotations = {
      "kubernetes.io/ingress.class" = "traefik"
    }
  }

  spec {
    rule {
      host = "traefik.telliott.io"

      http {
        path {
          path = "/"

          backend {
            service_name = "traefik-admin"
            service_port = "8080"
          }
        }
      }
    }
  }
}


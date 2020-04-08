resource "kubernetes_ingress" "consul" {
  depends_on = [helm_release.consul]

  metadata {
    name      = "consul-ingress"
    namespace = "consul"
    annotations = {
      "kubernetes.io/ingress.class"                    = "nginx"
      "nginx.ingress.kubernetes.io/server-alias"       = "consul.*"
    }
  }

  spec {
    rule {
      host = "consul"

      http {
        path {
          path = "/"

          backend {
            service_name = "consul"
            service_port = 8500
          }
        }
      }
    }
  }
}

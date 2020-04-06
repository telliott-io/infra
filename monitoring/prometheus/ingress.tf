resource "kubernetes_ingress" "prometheus" {
  depends_on = [null_resource.module_depends_on]
  
  metadata {
    name = "prometheus"
    namespace = "monitoring"
    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
      "nginx.ingress.kubernetes.io/server-alias" = "prometheus.*"
    }
  }

  spec {
    rule {
      host = "prometheus"

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


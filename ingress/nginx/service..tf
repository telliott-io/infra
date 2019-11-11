resource "kubernetes_service" "ingress_nginx" {
  metadata {
    name      = "ingress-nginx"
    namespace = "ingress-nginx"

    labels = {
      "app.kubernetes.io/name" = "ingress-nginx"

      "app.kubernetes.io/part-of" = "ingress-nginx"
    }
  }

  spec {
    port {
      name        = "http"
      port        = 80
      target_port = "http"
    }

    port {
      name        = "https"
      port        = 443
      target_port = "https"
    }

    selector = {
      "app.kubernetes.io/name" = "ingress-nginx"

      "app.kubernetes.io/part-of" = "ingress-nginx"
    }

    type                    = "LoadBalancer"
    external_traffic_policy = "Local"
  }
}


resource "kubernetes_service" "grafana" {
  metadata {
    name      = "grafana"
    namespace = "monitoring"

    labels = {
      app = "grafana"

      component = "core"
    }
  }

  spec {
    port {
      port = 3000
    }

    selector = {
      app = "grafana"

      component = "core"
    }

    type = "NodePort"
  }
}


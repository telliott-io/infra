resource "kubernetes_service" "grafana" {
  depends_on = [null_resource.module_depends_on]
  
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


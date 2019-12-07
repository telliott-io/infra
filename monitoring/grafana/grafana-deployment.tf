resource "kubernetes_deployment" "grafana" {
  metadata {
    name      = "grafana"
    namespace = "monitoring"

    labels = {
      app = "grafana"

      component = "core"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "grafana"
        component = "core"
      }
    }

    template {
      metadata {
        labels = {
          app = "grafana"

          component = "core"
        }
      }

      spec {
        volume {
          name="grafana-config"
          config_map {
            name = "grafana-config"
          }
        }

        container {
          name  = "grafana"
          image = "grafana/grafana:latest"

          env {
            name  = "GF_AUTH_BASIC_ENABLED"
            value = "true"
          }

          env {
            name  = "GF_AUTH_ANONYMOUS_ENABLED"
            value = "true"
          }

          env {
            name  = "GF_SECURITY_ADMIN_PASSWORD"
            value = "secret"
          }

          volume_mount {
            name = "grafana-config"
            mount_path = "/etc/grafana/provisioning/datasources"
          }
        }
      }
    }
  }
}


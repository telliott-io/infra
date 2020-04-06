resource "kubernetes_deployment" "jaeger" {
  depends_on = [null_resource.module_depends_on]

  metadata {
    name = "jaeger"
    namespace = "monitoring"

    labels = {
      "app.kubernetes.io/component" = "all-in-one"
      "app.kubernetes.io/name" = "jaeger"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        "app.kubernetes.io/component" = "all-in-one"
        "app.kubernetes.io/name" = "jaeger"
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/component" = "all-in-one"
          "app.kubernetes.io/name" = "jaeger"
        }

        annotations = {
          "prometheus.io/port" = "16686"

          "prometheus.io/scrape" = "true"
        }
      }

      spec {
        container {
          name  = "jaeger"
          image = "jaegertracing/all-in-one"

          port {
            container_port = 5775
            protocol       = "UDP"
          }

          port {
            container_port = 6831
            protocol       = "UDP"
          }

          port {
            container_port = 6832
            protocol       = "UDP"
          }

          port {
            container_port = 5778
            protocol       = "TCP"
          }

          port {
            container_port = 16686
            protocol       = "TCP"
          }

          port {
            container_port = 9411
            protocol       = "TCP"
          }

          env {
            name  = "COLLECTOR_ZIPKIN_HTTP_PORT"
            value = "9411"
          }

          readiness_probe {
            http_get {
              path = "/"
              port = "14269"
            }

            initial_delay_seconds = 5
          }
        }
      }
    }

    strategy {
      type = "Recreate"
    }
  }
}

resource "kubernetes_service" "jaeger_query" {
  depends_on = [null_resource.module_depends_on]
  
  metadata {
    name = "jaeger-query"
    namespace = "monitoring"

    labels = {


      "app.kubernetes.io/component" = "query"

      "app.kubernetes.io/name" = "jaeger"
    }
  }

  spec {
    port {
      name        = "query-http"
      protocol    = "TCP"
      port        = 80
      target_port = "16686"
    }

    selector = {
        "app.kubernetes.io/component" = "all-in-one"
        "app.kubernetes.io/name" = "jaeger"
    }

    type = "NodePort"
  }
}

resource "kubernetes_service" "jaeger_collector" {
  depends_on = [null_resource.module_depends_on]

  metadata {
    name = "jaeger-collector"
    namespace = "monitoring"

    labels = {


      "app.kubernetes.io/component" = "collector"

      "app.kubernetes.io/name" = "jaeger"
    }
  }

  spec {
    port {
      name        = "jaeger-collector-tchannel"
      protocol    = "TCP"
      port        = 14267
      target_port = "14267"
    }

    port {
      name        = "jaeger-collector-http"
      protocol    = "TCP"
      port        = 14268
      target_port = "14268"
    }

    port {
      name        = "jaeger-collector-zipkin"
      protocol    = "TCP"
      port        = 9411
      target_port = "9411"
    }

    selector = {
        "app.kubernetes.io/component" = "all-in-one"
        "app.kubernetes.io/name" = "jaeger"
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_service" "jaeger_agent" {
  depends_on = [null_resource.module_depends_on]

  metadata {
    name = "jaeger-agent"
    namespace = "monitoring"

    labels = {


      "app.kubernetes.io/component" = "agent"

      "app.kubernetes.io/name" = "jaeger"
    }
  }

  spec {
    port {
      name        = "agent-zipkin-thrift"
      protocol    = "UDP"
      port        = 5775
      target_port = "5775"
    }

    port {
      name        = "agent-compact"
      protocol    = "UDP"
      port        = 6831
      target_port = "6831"
    }

    port {
      name        = "agent-binary"
      protocol    = "UDP"
      port        = 6832
      target_port = "6832"
    }

    port {
      name        = "agent-configs"
      protocol    = "TCP"
      port        = 5778
      target_port = "5778"
    }

    selector = {
        "app.kubernetes.io/component" = "all-in-one"
        "app.kubernetes.io/name" = "jaeger"
    }

    cluster_ip = "None"
  }
}

resource "kubernetes_service" "zipkin" {
  depends_on = [null_resource.module_depends_on]
  
  metadata {
    name = "zipkin"
    namespace = "monitoring"

    labels = {


      "app.kubernetes.io/component" = "zipkin"

      "app.kubernetes.io/name" = "jaeger"
    }
  }

  spec {
    port {
      name        = "jaeger-collector-zipkin"
      protocol    = "TCP"
      port        = 9411
      target_port = "9411"
    }

    selector = {
        "app.kubernetes.io/component" = "all-in-one"
        "app.kubernetes.io/name" = "jaeger"
    }

    cluster_ip = "None"
  }
}


resource "kubernetes_service_account" "traefik_ingress_controller" {
  metadata {
    name      = "traefik-ingress-controller"
    namespace = "traefik"
  }
}

resource "kubernetes_daemonset" "traefik_ingress_controller" {
  metadata {
    name      = "traefik-ingress-controller"
    namespace = "traefik"

    labels = {
      k8s-app = "traefik-ingress-lb"
    }
  }

  spec {
    selector {
      match_labels = {
        k8s-app = "traefik-ingress-lb"

        name = "traefik-ingress-lb"
      }
    }

    template {
      metadata {
        labels = {
          k8s-app = "traefik-ingress-lb"

          name = "traefik-ingress-lb"
        }
      }

      spec {
        container {
          name  = "traefik-ingress-lb"
          image = "traefik:v1.7"
          args  = ["--api", "--kubernetes", "--logLevel=INFO"]

          port {
            name           = "http"
            host_port      = 80
            container_port = 80
          }

          port {
            name           = "tls"
            host_port      = 443
            container_port = 443
          }

          port {
            name           = "admin"
            host_port      = 8080
            container_port = 8080
          }
        }

        termination_grace_period_seconds = 60
        service_account_name             = "traefik-ingress-controller"
        automount_service_account_token = true
      }
    }
  }
}

resource "kubernetes_service" "traefik_ingress_service" {
  metadata {
    name      = "traefik-ingress-service"
    namespace = "traefik"
  }

  spec {
    port {
      name     = "web"
      protocol = "TCP"
      port     = 80
    }

    # port {
    #   name     = "tls"
    #   protocol = "TCP"
    #   port     = 443
    # }

    type                    = "LoadBalancer"
    load_balancer_ip = "${var.load_balancer_ip}"
    external_traffic_policy = "Local"

    selector = {
      k8s-app = "traefik-ingress-lb"
    }
  }
}

resource "kubernetes_service" "traefik_admin" {
  metadata {
    name      = "traefik-admin"
    namespace = "traefik"
  }

  spec {
    port {
      name     = "admin"
      protocol = "TCP"
      port     = 8080
    }

    selector = {
      k8s-app = "traefik-ingress-lb"
    }
  }
}


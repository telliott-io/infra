resource "kubernetes_cluster_role" "traefik_ingress_controller" {
  metadata {
    name = "traefik-ingress-controller"
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = [""]
    resources  = ["services", "endpoints", "secrets"]
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = ["extensions"]
    resources  = ["ingresses"]
  }

  rule {
    verbs      = ["update"]
    api_groups = ["extensions"]
    resources  = ["ingresses/status"]
  }
}

resource "kubernetes_cluster_role_binding" "traefik_ingress_controller" {
  metadata {
    name = "traefik-ingress-controller"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "traefik-ingress-controller"
    namespace = "traefik"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "traefik-ingress-controller"
  }
}


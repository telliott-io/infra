resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }

  timeouts {
    delete = "2h"
  }
}

resource "helm_release" "argocd" {
  depends_on = [kubernetes_namespace.argocd]

  name       = "argo"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  namespace  = "argocd"
  version    = "2.3.4"

  set_sensitive {
    name  = "configs.secret.argocdServerAdminPassword"
    value = var.argocd_admin_password
  }

  set {
    name = "server.rbacConfig.policy\\.default"
    value = "role:readonly"
  }

  set {
    name = "server.config.users\\.anonymous\\.enabled"
    value = "true"
    type = "string"
  }

  set {
    name = "installCRDs"
    value = false
  }
}

variable argocd_admin_password {}
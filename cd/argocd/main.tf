data "helm_repository" "argocd" {
    name = "argo"
    url  = "https://argoproj.github.io/argo-helm"
}

resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }

  timeouts {
    create = "60m"
    delete = "2h"
  }
}

resource "helm_release" "argocd" {
  depends_on = [kubernetes_namespace.argocd]

  name       = "argo"
  repository = data.helm_repository.argocd.metadata[0].name
  chart      = "argo/argo-cd"
  namespace  = "argocd"

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
}

variable argocd_admin_password {}
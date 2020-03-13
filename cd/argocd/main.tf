data "helm_repository" "argocd" {
    name = "argo"
    url  = "https://argoproj.github.io/argo-helm"
}

resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
}

resource "helm_release" "argocd" {
  name       = "argo"
  repository = data.helm_repository.argocd.metadata[0].name
  chart      = "argo/argo-cd"
  namespace  = "argocd"

  set {
    name  = "configs.secret.argocdServerAdminPassword"
    value = var.argocd_admin_password
  }
}

variable argocd_admin_password {}
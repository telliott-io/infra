resource "kubernetes_namespace" "secrets" {
  metadata {
    name = "secrets"
  }
}

resource "helm_release" "sealed-secrets" {
  depends_on = [kubernetes_namespace.secrets]

  name  = "sealed-secrets-controller"
  chart = "stable/sealed-secrets"
  namespace = "secrets"

  set {
    name = "secretName"
    value = "secret-signing-certs"
    type = "string"
  }
}
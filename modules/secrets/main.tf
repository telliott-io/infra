resource "helm_release" "sealed-secrets" {
  name  = "sealed-secrets-controller"
  chart = "stable/sealed-secrets"
  namespace = "secrets"
  create_namespace = true

  set {
    name = "secretName"
    value = "secret-signing-certs"
    type = "string"
  }
}
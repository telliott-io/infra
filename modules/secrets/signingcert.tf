resource "kubernetes_secret" "signing-cert" {
  depends_on = [helm_release.sealed-secrets]
  metadata {
    name = "secret-signing-certs"
    namespace = "secrets"
    labels = {
        "sealedsecrets.bitnami.com/sealed-secrets-key" = "active"
    }
  }



  data = {
    "tls.crt" = var.signing_cert
    "tls.key" = var.signing_key
  }

  type = "kubernetes.io/tls"
}
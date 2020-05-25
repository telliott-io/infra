resource "kubernetes_secret" "signing-cert" {
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
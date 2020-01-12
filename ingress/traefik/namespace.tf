resource "kubernetes_namespace" "traefik" {
  metadata {
    name = "traefik"

    labels = {
      "app.kubernetes.io/name" = "traefik"
      "app.kubernetes.io/part-of" = "traefik"
    }
  }
}
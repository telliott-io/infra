resource "kubernetes_namespace" "consul" {
  metadata {
    name = "consul"
  }
}

resource "helm_release" "consul" {
  name  = "consul"
  chart = "stable/consul"
  namespace  = "consul"
}
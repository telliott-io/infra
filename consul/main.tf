resource "kubernetes_namespace" "consul" {
  depends_on = [null_resource.module_depends_on]

  metadata {
    name = "consul"
  }
}

resource "helm_release" "consul" {
  depends_on = [kubernetes_namespace.consul]

  name  = "consul"
  chart = "stable/consul"
  namespace  = "consul"

  set {
    name = "acl.enabled"
    value = true
  }

  set {
    name = "DatacenterName"
    value = "telliott-io"
  }

  set {
    name = "Replicas"
    value = 3
  }
}
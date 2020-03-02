data "helm_repository" "concourse" {
    name = "concourse"
    url  = "https://concourse-charts.storage.googleapis.com/"
}

resource "kubernetes_namespace" "concourse" {
  metadata {
    name = "concourse"
  }
}

resource "helm_release" "concourse" {
  name       = "concourse"
  repository = data.helm_repository.concourse.metadata[0].name
  chart      = "concourse/concourse"
  namespace  = "concourse"
}
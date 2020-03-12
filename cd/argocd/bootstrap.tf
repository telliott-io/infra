data "helm_repository" "bootstrap" {
    name = "bootstrap"
    url  = "https://telliott-io.github.io/bootstrap"
}

resource "helm_release" "bootstrap" {
  name       = "bootstrap"
  repository = data.helm_repository.bootstrap.metadata[0].name
  chart      = "bootstrap/bootstrap"
  namespace  = "argocd"
  version    = "0.1.3"
}
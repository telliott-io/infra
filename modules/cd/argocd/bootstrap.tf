resource "helm_release" "bootstrap" {
  depends_on = [helm_release.argocd]

  name       = "bootstrap"
  repository = "https://telliott-io.github.io/bootstrap"
  chart      = "bootstrap"
  namespace  = "argocd"
  version    = "0.1.3"
}
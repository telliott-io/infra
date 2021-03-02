module "site1" {
  source   = "./site"
  cluster_name = "site1"
  argocd_admin_password = var.argocd_admin_password
  vcs_oauth_token_id = var.vcs_oauth_token_id
  dns_name = var.dns_name
}
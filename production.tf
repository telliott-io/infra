module "production" {
  source   = "./site"
  cluster_name = "production"
  argocd_admin_password = var.argocd_admin_password
  vcs_oauth_token_id = var.vcs_oauth_token_id
}
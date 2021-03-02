module "sitecluster" {
  source   = "github.com/telliott-io/kube-clusters//digitalocean?ref=v0.6.1"
  cluster_name = var.cluster_name
}

resource "tfe_workspace" "siteplatform" {
  name         = "platform-${var.cluster_name}"
  organization = "telliott-io"
  auto_apply = "true"
  terraform_version = "0.13.6"
  vcs_repo {
	  identifier = "telliott-io/platform"
	  oauth_token_id = var.vcs_oauth_token_id
  }

  depends_on = [
    module.sitecluster.kubernetes,
  ]
}

resource "tfe_variable" "site_kubernetes" {
  key          = "kubernetes"
  value        = jsonencode(module.sitecluster.kubernetes)
  category     = "terraform"
  workspace_id = tfe_workspace.siteplatform.id
  description  = "Kubernetes cluster configuration"
  sensitive = "true"
}

resource "tfe_variable" "site_environment" {
  key          = "environment"
  value        = var.cluster_name
  category     = "terraform"
  workspace_id = tfe_workspace.siteplatform.id
  description  = "Environment name"
}

resource "tfe_variable" "site_hostname" {
  key          = "hostname"
  value        = "telliott.io"
  category     = "terraform"
  workspace_id = tfe_workspace.siteplatform.id
  description  = "Hostname for sites"
}

resource "tfe_variable" "site_argo_password" {
  key          = "argocd_admin_password"
  value        = var.argocd_admin_password
  category     = "terraform"
  workspace_id = tfe_workspace.siteplatform.id
  description  = "Password for ArgoCD Admin"
}

resource "tfe_variable" "site_bootstrap_repository" {
  key          = "bootstrap_repository"
  value        = "https://telliott-io.github.io/bootstrap"
  category     = "terraform"
  workspace_id = tfe_workspace.siteplatform.id
  description  = "Helm repository for bootstrapping ArgoCD"
}

resource "tfe_variable" "site_bootstrap_chart" {
  key          = "bootstrap_chart"
  value        = "bootstrap"
  category     = "terraform"
  workspace_id = tfe_workspace.siteplatform.id
  description  = "Helm chart for bootstrapping ArgoCD"
}

resource "tfe_variable" "site_bootstrap_version" {
  key          = "bootstrap_version"
  value        = "0.1.3"
  category     = "terraform"
  workspace_id = tfe_workspace.siteplatform.id
  description  = "Helm chart version for bootstrapping ArgoCD"
}

resource "tfe_variable" "site_dns_name" {
  key          = "dns_name"
  value        = var.dns_name
  category     = "terraform"
  workspace_id = tfe_workspace.siteplatform.id
  description  = "DNS name for site"
}

data "tfe_workspace_ids" "infra_workspace" {
  names        = ["infra"]
  organization = "telliott-io"
}

resource "tfe_run_trigger" "site_run_trigger" {
  workspace_id  = tfe_workspace.siteplatform.id
  sourceable_id = data.tfe_workspace_ids.infra_workspace.ids["infra"]
}
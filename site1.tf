module "site1cluster" {
  source   = "github.com/telliott-io/kube-clusters//digitalocean?ref=v0.6.1"
  cluster_name = "site1"
}

resource "tfe_workspace" "site1platform" {
  name         = "platform-site1"
  organization = "telliott-io"
  auto_apply = "true"
  terraform_version = "0.13.6"
  vcs_repo {
	  identifier = "telliott-io/platform"
	  oauth_token_id = var.vcs_oauth_token_id
  }

  depends_on = [
    module.site1cluster.kubernetes,
  ]
}

resource "tfe_variable" "site1_kubernetes" {
  key          = "kubernetes"
  value        = jsonencode(module.site1cluster.kubernetes)
  category     = "terraform"
  workspace_id = tfe_workspace.site1platform.id
  description  = "Kubernetes cluster configuration"
  sensitive = "true"
}

resource "tfe_variable" "site1_environment" {
  key          = "environment"
  value        = "site1"
  category     = "terraform"
  workspace_id = tfe_workspace.site1platform.id
  description  = "Environment name"
}

resource "tfe_variable" "site1_hostname" {
  key          = "hostname"
  value        = "telliott.io"
  category     = "terraform"
  workspace_id = tfe_workspace.site1platform.id
  description  = "Hostname for sites"
}

resource "tfe_variable" "site1_argo_password" {
  key          = "argocd_admin_password"
  value        = var.argocd_admin_password
  category     = "terraform"
  workspace_id = tfe_workspace.site1platform.id
  description  = "Password for ArgoCD Admin"
}

resource "tfe_variable" "site1_bootstrap_repository" {
  key          = "bootstrap_repository"
  value        = "https://telliott-io.github.io/bootstrap"
  category     = "terraform"
  workspace_id = tfe_workspace.site1platform.id
  description  = "Helm repository for bootstrapping ArgoCD"
}

resource "tfe_variable" "site1_bootstrap_chart" {
  key          = "bootstrap_chart"
  value        = "bootstrap"
  category     = "terraform"
  workspace_id = tfe_workspace.site1platform.id
  description  = "Helm chart for bootstrapping ArgoCD"
}

resource "tfe_variable" "site1_bootstrap_version" {
  key          = "bootstrap_version"
  value        = "0.1.3"
  category     = "terraform"
  workspace_id = tfe_workspace.site1platform.id
  description  = "Helm chart version for bootstrapping ArgoCD"
}

resource "tfe_variable" "site1_dns_name" {
  key          = "dns_name"
  value        = var.dns_name
  category     = "terraform"
  workspace_id = tfe_workspace.site1platform.id
  description  = "DNS name for site"
}

data "tfe_workspace_ids" "infra_workspace" {
  names        = ["infra"]
  organization = "telliott-io"
}

resource "tfe_run_trigger" "site1_run_trigger" {
  workspace_id  = tfe_workspace.site1platform.id
  sourceable_id = data.tfe_workspace_ids.infra_workspace.ids["infra"]
}
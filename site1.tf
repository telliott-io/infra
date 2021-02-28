module "site1cluster" {
  source   = "github.com/telliott-io/kube-clusters//digitalocean?ref=v0.6.1"
  cluster_name = "site1"
}

resource "tfe_workspace" "site1platform" {
  name         = "platform-site1"
  organization = "telliott-io"
  vcs_repo {
	  identifier = "telliott-io/platform"
	  oauth_token_id = var.vcs_oauth_token_id
  }
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
  value        = "secret"
  category     = "terraform"
  workspace_id = tfe_workspace.site1platform.id
  description  = "Password for ArgoCD Admin"
}

resource "tfe_variable" "site1_bootstrap_repository" {
  key          = "bootstrap_repository"
  value        = "https://telliott-io.github.io/testbootstrap"
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
  value        = "0.1.1"
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
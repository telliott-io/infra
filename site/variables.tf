
variable cluster_name {}

variable argocd_admin_password {}

variable vcs_oauth_token_id {}

variable terraform_version {
    type = string
    default = "0.1.3"
    description = "Terraform version to be used in the platform workspace for this site"
}
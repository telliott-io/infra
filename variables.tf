#####################################################################
# Variables
#####################################################################
variable cloudflare_email {}
variable cloudflare_api_key {}
variable cloudflare_zone_id {}
variable "do_token" {} # Digital Ocean auth token

# Initial admin password for ArgoCD
# bcrypt hashed:
# $ htpasswd -nbBC 10 "" "secret"  | tr -d ':\n'
variable argocd_admin_password {}

# Keypair for use with sealed secrets
variable secret_signing_cert {}
variable secret_signing_key {}
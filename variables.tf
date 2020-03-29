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
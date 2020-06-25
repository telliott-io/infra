module "dns" {
  source = "../../modules/dns"
  cloudflare_zone_id = "${var.cloudflare_zone_id}"
  ingress_ip = var.ingress_address
  domain = "telliott.io"
}

variable "ingress_address" {}
variable cloudflare_zone_id {}
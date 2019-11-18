resource "cloudflare_record" "ingress" {
  zone_id = "${var.cloudflare_zone_id}"
  name    = "ingress"
  value   = "${var.ingress_address}"
  type    = "A"
  ttl     = 1
}

resource "cloudflare_record" "blogarchive" {
  zone_id = "${var.cloudflare_zone_id}"
  name    = "blogarchive"
  value   = "ingress.telliott.io"
  type    = "CNAME"
  ttl     = 1
}

resource "cloudflare_record" "front" {
  zone_id = "${var.cloudflare_zone_id}"
  name    = "front"
  value   = "ingress.telliott.io"
  type    = "CNAME"
  ttl     = 1
}
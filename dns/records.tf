resource "cloudflare_record" "ingress" {
  zone_id = "${var.cloudflare_zone_id}"
  name    = "ingress"
  value   = "${var.ingress_address}"
  type    = "A"
  ttl     = 1
  proxied = true
}

resource "cloudflare_record" "do_ingress" {
  zone_id = "${var.cloudflare_zone_id}"
  name    = "digitalocean"
  value   = "${var.do_ingress_address}"
  type    = "A"
  ttl     = 1
  proxied = true
}

resource "cloudflare_record" "traefik" {
  zone_id = "${var.cloudflare_zone_id}"
  name    = "traefik"
  value   = "${var.traefik_ingress_address}"
  type    = "A"
  ttl     = 1
  proxied = true
}

resource "cloudflare_record" "jaeger" {
  zone_id = "${var.cloudflare_zone_id}"
  name    = "jaeger"
  value   = "ingress.${var.domain}"
  type    = "CNAME"
  ttl     = 1
  proxied = true
}

resource "cloudflare_record" "prometheus" {
  zone_id = "${var.cloudflare_zone_id}"
  name    = "prometheus"
  value   = "ingress.${var.domain}"
  type    = "CNAME"
  ttl     = 1
  proxied = true
}

resource "cloudflare_record" "grafana" {
  zone_id = "${var.cloudflare_zone_id}"
  name    = "grafana"
  value   = "ingress.${var.domain}"
  type    = "CNAME"
  ttl     = 1
  proxied = true
}
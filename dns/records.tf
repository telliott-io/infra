resource "cloudflare_record" "ingress" {
  for_each = var.ingress_ips

  zone_id = var.cloudflare_zone_id
  name    = "ingress"
  value   = each.key
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
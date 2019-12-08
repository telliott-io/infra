resource "cloudflare_record" "ingress" {
  zone_id = "${var.cloudflare_zone_id}"
  name    = "ingress"
  value   = "${var.ingress_address}"
  type    = "A"
  ttl     = 1
  proxied = true
}

resource "cloudflare_record" "blogarchive" {
  zone_id = "${var.cloudflare_zone_id}"
  name    = "blogarchive"
  value   = "ingress.telliott.io"
  type    = "CNAME"
  ttl     = 1
  proxied = true
}

resource "cloudflare_record" "front" {
  zone_id = "${var.cloudflare_zone_id}"
  name    = "front"
  value   = "ingress.telliott.io"
  type    = "CNAME"
  ttl     = 1
  proxied = true
}

resource "cloudflare_record" "jaeger" {
  zone_id = "${var.cloudflare_zone_id}"
  name    = "jaeger"
  value   = "ingress.telliott.io"
  type    = "CNAME"
  ttl     = 1
  proxied = true
}

resource "cloudflare_record" "prometheus" {
  zone_id = "${var.cloudflare_zone_id}"
  name    = "prometheus"
  value   = "ingress.telliott.io"
  type    = "CNAME"
  ttl     = 1
  proxied = true
}


resource "cloudflare_record" "grafana" {
  zone_id = "${var.cloudflare_zone_id}"
  name    = "grafana"
  value   = "ingress.telliott.io"
  type    = "CNAME"
  ttl     = 1
  proxied = true
}
resource "google_compute_address" "ip_address" {
    name = "primary-ingress"
}

resource "google_compute_address" "traefik_ip_address" {
    name = "traefik-ingress"
}

output "ingress_address" {
    value = "${google_compute_address.ip_address.address}"
}

output "traefik_ingress_address" {
    value = "${google_compute_address.traefik_ip_address.address}"
}
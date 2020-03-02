resource "google_compute_address" "ip_address" {
    name = "primary-ingress"
}

output "ingress_address" {
    value = "${google_compute_address.ip_address.address}"
}

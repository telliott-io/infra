resource "google_compute_address" "ip_address" {
    name = "primary-ingress"
}

resource "local_file" "ipfile" {
    content     = "${google_compute_address.ip_address.address}"
    filename = "${path.module}/ipaddress.txt"
}

output "ingress_address" {
    value = "${google_compute_address.ip_address.address}"
}
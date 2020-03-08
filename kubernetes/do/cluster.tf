resource "digitalocean_kubernetes_cluster" "primary" {
  name    = var.name
  region  = "nyc1"
  # Grab the latest version slug from `doctl kubernetes options versions`
  version = "1.16.6-do.0"
  tags    = ["staging"]

  node_pool {
    name       = "worker-pool"
    size       = var.size
    node_count = 3
  }
}

output "host" {
  value = digitalocean_kubernetes_cluster.primary.endpoint
}

output "token" {
  value = digitalocean_kubernetes_cluster.primary.kube_config[0].token
}

output "cluster_ca_certificate" {
  value = base64decode(
    digitalocean_kubernetes_cluster.primary.kube_config[0].cluster_ca_certificate
  )
}
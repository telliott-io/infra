resource "digitalocean_kubernetes_cluster" "primary" {
  name    = "primary"
  region  = "nyc1"
  # Grab the latest version slug from `doctl kubernetes options versions`
  version = "1.16.6-do.0"
  tags    = ["staging"]

  node_pool {
    name       = "worker-pool"
    size       = "s-2vcpu-2gb"
    node_count = 3
  }
}

provider "kubernetes" {
  load_config_file = false
  host  = digitalocean_kubernetes_cluster.primary.endpoint
  token = digitalocean_kubernetes_cluster.primary.kube_config[0].token
  cluster_ca_certificate = digitalocean_kubernetes_cluster.primary.kube_config[0].cluster_ca_certificate
}

provider "helm" {
  kubernetes {
    host  = digitalocean_kubernetes_cluster.primary.endpoint
    token = digitalocean_kubernetes_cluster.primary.kube_config[0].token
    cluster_ca_certificate = digitalocean_kubernetes_cluster.primary.kube_config[0].cluster_ca_certificate
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
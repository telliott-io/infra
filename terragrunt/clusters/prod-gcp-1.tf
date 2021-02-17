module "prod-gke-1" {
  source   = "github.com/telliott-io/kube-clusters//gke?ref=v0.4.1"
  cluster_name = "prod-gke-1"
}

output "prod-gke-1" {
  value = module.prod-gke-1.kubernetes
  sensitive = true
}

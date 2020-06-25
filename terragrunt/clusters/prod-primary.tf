module "prod-primary" {
  source   = "github.com/telliott-io/kube-clusters//digitalocean"
  cluster_name = "prod-primary"
}

output "prod-primary" {
  value = module.prod-primary.kubernetes
  sensitive = true
}

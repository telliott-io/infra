module "prod-primary" {
  source   = "github.com/telliott-io/kube-clusters//digitalocean?ref=v0.1.0"
  cluster_name = "prod-primary"
}

output "prod-primary" {
  value = module.prod-primary.kubernetes
  sensitive = true
}

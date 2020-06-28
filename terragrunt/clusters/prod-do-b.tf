module "prod-do-b" {
  source   = "github.com/telliott-io/kube-clusters//digitalocean?ref=v0.2.0"
  cluster_name = "prod-do-b"
}

output "prod-do-b" {
  value = module.prod-do-b.kubernetes
  sensitive = true
}

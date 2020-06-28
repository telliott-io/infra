module "prod-do-a" {
  source   = "github.com/telliott-io/kube-clusters//digitalocean?ref=v0.2.0"
  cluster_name = "prod-do-a"
}

output "prod-do-a" {
  value = module.prod-do-a.kubernetes
  sensitive = true
}

module "prod-do-c" {
  source   = "github.com/telliott-io/kube-clusters//digitalocean?ref=v0.3.0"
  cluster_name = "prod-do-c"
}

output "prod-do-c" {
  value = module.prod-do-c.kubernetes
  sensitive = true
}

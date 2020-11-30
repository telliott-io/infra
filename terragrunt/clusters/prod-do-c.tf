module "prod-do-c" {
  source   = "github.com/telliott-io/kube-clusters//digitalocean?ref=v0.4.1"
  cluster_name = "prod-do-c"
}

output "prod-do-c" {
  value = module.prod-do-c.kubernetes
  sensitive = true
}

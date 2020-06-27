module "do-prod-a" {
  source   = "github.com/telliott-io/kube-clusters//digitalocean?ref=v0.2.0"
  cluster_name = "do-prod-a"
}

output "do-prod-a" {
  value = module.do-prod-a.kubernetes
  sensitive = true
}

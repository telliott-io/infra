terraform {
  source = "github.com/telliott-io/infra//modules/configuration"
}

dependency "clusters" {
  config_path = "../../clusters"
}

inputs = {
  kubernetes = dependency.clusters.outputs.prod-do-b
  environment = "prod-digitalocean-b"
  bootstrap_repository = "https://telliott-io.github.io/bootstrap"
  bootstrap_chart = "bootstrap"
}
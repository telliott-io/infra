include {
  path = find_in_parent_folders()
}

terraform {
  source = "github.com/telliott-io/infra//modules/configuration"
}

dependency "clusters" {
  config_path = "../../clusters"
}

inputs = {
  kubernetes = dependency.clusters.outputs.prod-do-a
  environment = "prod-digitalocean-a"
  bootstrap_repository = "https://telliott-io.github.io/bootstrap"
  bootstrap_chart = "bootstrap"
}
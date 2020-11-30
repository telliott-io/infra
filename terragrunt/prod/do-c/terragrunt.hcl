include {
  path = find_in_parent_folders()
}

terraform {
  source = "github.com/telliott-io/platform?ref=v0.3.2"
}

dependency "clusters" {
  config_path = "../../clusters"
}

inputs = {
  kubernetes = dependency.clusters.outputs.prod-do-c
  environment = "prod-digitalocean-c"
  bootstrap_repository = "https://telliott-io.github.io/bootstrap"
  bootstrap_chart = "bootstrap"
}
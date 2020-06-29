include {
  path = find_in_parent_folders()
}

terraform {
  source = "github.com/telliott-io/platform?ref=v0.1.1"
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
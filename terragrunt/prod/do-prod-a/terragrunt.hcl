# stage/mysql/terragrunt.hcl
include {
  path = find_in_parent_folders()
}

dependency "clusters" {
  config_path = "../../clusters"
}

inputs = {
  config = dependency.clusters.outputs.do-prod-a
}
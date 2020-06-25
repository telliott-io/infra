include {
  path = find_in_parent_folders()
}

dependency "primary" {
  config_path = "../prod/primary"
}

inputs = {
  ingress_address = dependency.primary.outputs.ingress_address
}
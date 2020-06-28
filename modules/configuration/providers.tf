
provider "kubernetes" {
    load_config_file = false
    host     = jsondecode(var.kubernetes).host
    username = jsondecode(var.kubernetes).username
    password = jsondecode(var.kubernetes).password
    cluster_ca_certificate = jsondecode(var.kubernetes).cluster_ca_certificate
    token = jsondecode(var.kubernetes).token
}

provider "helm" {
  kubernetes {
    load_config_file = false
    host     = jsondecode(var.kubernetes).host
    username = jsondecode(var.kubernetes).username
    password = jsondecode(var.kubernetes).password
    cluster_ca_certificate = jsondecode(var.kubernetes).cluster_ca_certificate
    token = jsondecode(var.kubernetes).token
  }
}

variable kubernetes {}
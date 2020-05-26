module "secrets" {
    source = "../../"
    signing_cert = var.signing_cert
    signing_key = var.signing_key
}

provider "kubernetes" {
    config_path = "${path.module}/kindconfig"
}

provider "helm" {
    kubernetes {
        config_path = "${path.module}/kindconfig"
    }
}

data "google_client_config" "current" {}

provider "kubernetes" {
  load_config_file = false
  host     = "${module.gke.host}"

  cluster_ca_certificate = "${base64decode(module.gke.cluster_ca_certificate)}"
  token = "${data.google_client_config.current.access_token}"
}

provider "helm" {
  kubernetes {
    host     = "${module.gke.host}"
    
    cluster_ca_certificate = "${base64decode(module.gke.cluster_ca_certificate)}"
    token = "${data.google_client_config.current.access_token}"
  }
}

provider "google" {
  credentials = "${file("gcloud-credentials.json")}"
  project     = "telliott-io"
  region      = "us-central1"
  zone        = "us-central1-c"
}

# Configure the Cloudflare provider.
# You may optionally use version directive to prevent breaking changes occurring unannounced.
provider "cloudflare" {
  version = "~> 2.0"
  email   = "${var.cloudflare_email}"
  api_key = "${var.cloudflare_api_key}"
}

# Configure the DigitalOcean Provider
provider "digitalocean" {
  token = "${var.do_token}"
}

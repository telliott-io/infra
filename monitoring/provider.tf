# Query my Terraform service account from GCP
data "google_client_config" "current" {}

provider "kubernetes" {
  load_config_file = false
  host     = "${var.host}"

  cluster_ca_certificate = "${base64decode(var.cluster_ca_certificate)}"
  token = "${data.google_client_config.current.access_token}"
}

provider "google" {
  credentials = "${file("gcloud-credentials.json")}"
  project     = "telliott-io"
  region      = "us-central1"
  zone        = "us-central1-c"
}

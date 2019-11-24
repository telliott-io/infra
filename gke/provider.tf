provider "google" {
  project     = "telliott-io"
  region      = "us-central1"
  zone        = "us-central1-c"

  credentials = "${file("gcloud-credentials.json")}"
}

# Query my Terraform service account from GCP
data "google_client_config" "current" {}

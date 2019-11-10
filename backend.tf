terraform {
  backend "gcs" {
    bucket  = "telliott-io-tf-state"
    prefix  = "terraform/state"
    credentials = "gcloud-credentials.json"
  }
}
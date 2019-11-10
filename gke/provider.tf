provider "google" {
  credentials = "${file("gcloud-credentials.json")}"
  project     = "telliott-io"
  region      = "us-central1"
  zone        = "us-central1-c"
}

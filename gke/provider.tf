provider "google" {
  project     = "telliott-io"
  region      = "us-central1"
  zone        = "us-central1-c"

  credentials = "${file("gcloud-credentials.json")}"
}

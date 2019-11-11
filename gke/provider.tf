provider "google" {
  project     = "telliott-io"
  region      = "us-central1"
  zone        = "us-central1-c"

  access_token = "${var.token}"
}

terraform {
  backend "gcs" {
    bucket  = "telliott-io-tf-state"
    prefix  = "terraform/state"
    credentials = "gcloud-credentials.json"
  }
}

provider "google" {
  credentials = "${file("gcloud-credentials.json")}"
  project     = "telliott-io"
  region      = "us-central1"
  zone        = "us-central1-c"
}

resource "google_container_cluster" "primary" {
  name     = "primary"
  location = "us-central1"

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count = 1

  node_locations = [
    "us-central1-c",
  ]

  master_auth {
    username = ""
    password = ""

    client_certificate_config {
      issue_client_certificate = false
    }
  }
}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = "primary-pool"
  location   = "us-central1"
  cluster    = "${google_container_cluster.primary.name}"
  node_count = 1

  node_config {
    preemptible  = true
    machine_type = "f1-micro"

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}
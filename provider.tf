# Configure provider
terraform {
  required_providers {
    google = {
        source = "hashicorp/google"
        version = "4.73.0"
    }
  }
}

provider "google" {
    credentials = file("credentials.json")
    project     = var.project_id
    region      = var.region
    zone        = var.zone
}

provider "google-beta" {
    project     = var.project_id
    region      = var.region
}
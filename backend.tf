terraform {
  backend "gcs" {
    bucket  = "otto-prod-terraform-state"
    prefix  = "terraform/state"
  }
}
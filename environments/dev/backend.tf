terraform {
  backend "gcs" {
    bucket  = "otto-prod-terraform-state-dev"
    prefix  = "terraform/state"
  }
}
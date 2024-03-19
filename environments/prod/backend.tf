terraform {
  backend "gcs" {
    bucket  = "otto-prod-terraform-state-prod"
    prefix  = "terraform/state"
  }
}
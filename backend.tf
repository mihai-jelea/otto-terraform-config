terraform {
  backend "gcs" {
    bucket  = "otto-prod-terraform-state"
    prefix  = "terraform/state"
    project = "otto-prod-17032024"
  }
}
# This module enables the required APIs
module "project-services" {
  source  = "terraform-google-modules/project-factory/google//modules/project_services"
  version = "~> 12.0"

  project_id  = var.project_id

  activate_apis = [
    "compute.googleapis.com",
    "storage.googleapis.com",
    "sqladmin.googleapis.com",
    "monitoring.googleapis.com",
    "logging.googleapis.com",
    "dns.googleapis.com"
  ]

  # This disables the API after the service is destroyed
  disable_services_on_destroy = true
}
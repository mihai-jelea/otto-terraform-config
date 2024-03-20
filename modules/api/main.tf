# Enable required APIs

# Enable Compute Engine API
resource "google_project_service" "compute" {
  service                    = "compute.googleapis.com"
  disable_on_destroy         = true
}

# Enable Cloud SQL API
resource "google_project_service" "compute" {
  service                    = "cloudsql.googleapis.com"
  disable_on_destroy         = true
}

# Enable Kubernetes Engine API
resource "google_project_service" "compute" {
  service                    = "container.googleapis.com"
  disable_on_destroy         = true
}

# Enable BigQuery API
resource "google_project_service" "compute" {
  service                    = "bigquery.googleapis.com"
  disable_on_destroy         = true
}

# Enable DNS API
resource "google_project_service" "compute" {
  service                    = "dns.googleapis.com"
  disable_on_destroy         = true
}

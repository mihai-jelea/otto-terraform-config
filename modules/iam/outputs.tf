output "web_app_id" {
    description = "ID of the Service Account used by the GCE instances running the web app in MIGs"
    value = google_service_account.web_app_sa.id
}

output "web_app_email" {
    description = "Email of the Service Account used by the GCE instances running the web app in MIGs"
    value = google_service_account.web_app_sa.email
}
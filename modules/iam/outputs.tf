output "web_app_sa" {
    description = "The Service Account used by the GCE instances running the web app in MIGs"
    value = google_service_account.web_app_sa.self_link
}
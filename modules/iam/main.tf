# Create a service account for the VMs in the MIGs
resource "google_service_account" "web_app_sa" {
    account_id   = "web-app-sa"
    display_name = "My Service Account"
    description  = "Service account to be used by the VMs in the MIGs"
}

# Assign Roles to the SA
resource "google_project_iam_binding" "cloud_sql_role" {
    for_each  = toset(var.roles)

    project   = var.project_id
    role      = each.value
    members   = "serviceAccount:${google_service_account.web_app_sa.email}"
}

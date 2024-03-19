module "main" {
  source            = "../.."

  project_id        = var.project_id
  credentials       = var.credentials
  region            = var.region
  zone              = var.zone
  disk_image_uri    = var.disk_image_uri
}
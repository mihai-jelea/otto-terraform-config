# Enable APIs
module "api" {
    source = "./modules/api"
}

# Configure IAM
module "iam" {
    source      = "./modules/iam"

    project_id  = var.project_id
    roles       = ["roles/cloudsql.client", "roles/logging.logWriter", "roles/monitoring.metricWriter", "roles/stackdriver.resourceMetadata.writer", "roles/monitoring.viewer"]
}

# Create VPC
module "network" {
    source      = "./modules/network"

    # Set general params
    region      = var.region
    project_id  = var.project_id

    # Set the VPC params
    vpc_name        = "europe"
    vpc_description = "The VPC for Europe"

    # Set the subnets params
    external_subnet_name        = "external"
    external_subnet_cidr_range  = "10.10.20.0/24"
    internal_subnet_name        = "internal"
    internal_subnet_cidr_range  = "10.10.30.0/24"

    # Set name for the Cloud Router
    cloud_router_name = "cloud_router"
}

# Create the MIGs, UMIGs and LBs
module "compute" {
    source               = "./modules/compute"

    project_id           = var.project_id
    region               = var.region
    mig_template_name    = "mig-web-app-template"
    web_app_machine_type = "n2-standard-4"
    web_app_disk_size    = 100
    disk_image_uri       = var.disk_image_uri
}

# Create the CloudSQL instance and database
module "database" {
    source              = "./modules/database"

    project_id          = var.project_id
    region              = var.region
    db_machine_type     = "db-highmem-16"
    db_disk_size        = 600
    prod_db_name        = "prod-db"
}
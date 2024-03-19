# Create CloudSQL instance
resource "google_sql_database_instance" "mysql_prod" {
    name             = "mysql-prod"
    project          = var.project_id
    region           = var.region
    database_version = "MYSQL_8_0"

    settings {
        tier            = var.db_machine_type
        disk_size       = var.db_disk_size
        disk_autoresize = true

        ip_configuration {
        ipv4_enabled    = false
        private_network = module.network.vpc
        }
    }
}

# Create production database
resource "google_sql_database" "prod_db" {
    name        = var.prod_db_name
    instance    = google_sql_database_instance.mysql_prod.self_link
}

output "mysql_prod" {
    description = "Production CloudSQL instance"
    value = google_sql_database_instance.mysql_prod.self_link
}

output "prod_db" {
    description = "Production database"
    value = google_sql_database.prod_db.self_link
}
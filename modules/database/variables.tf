variable "project_id" {
    description = "The ID of the project where the infrastructure will be deployed"
    type        = string
    nullable    = false
}

variable "region" {
    description = "The region where the resource should be deployed"
    type        = string
    nullable    = false
}

variable "db_machine_type" {
    description = "Set the machine type for the CloudSQL instance"
    type = string
    nullable = false
}

variable "db_disk_size" {
    description = "The size of the disk for the CloudSQL instance"
    type = number
    default = 500
}

variable "prod_db_name" {
    description = "The name of the production database"
    type = string
    default = "prod_db"
}
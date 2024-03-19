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

variable "disk_image_uri" {
    description = "The URI of the custom image. This should point to an image file in a GCS bucket"
    type        = string
    nullable    = false
}

variable "mig_template_name" {
    description = "The name for the instance template that will be used by MIGs"
    type        = string
    nullable    = false
}

variable "web_app_machine_type" {
    description = "The machine type for the web servers"
    type        = string
    nullable    = false
}

variable "web_app_disk_size" {
    description = "The size of the disk used by the web-app VM"
    type        = string
    nullable    = false
}
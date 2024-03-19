variable "project_id" {
    description = "The ID of the project where the infrastructure will be deployed"
    type        = string
    nullable    = false
}

variable "billing_account_id" {
    description = "The ID of the billing account linked to the project"
    type        = string
    nullable    = false
}

variable "region" {
    description = "The region where the resources will be deployed to"
    type        = string
    nullable    = false
}

variable "zone" {
    description = "The zone where the resources will be deployed to"
    type        = string
    nullable    = true
}

variable "credentials" {
    description = "The path to the service account key json file"
    type        = string
    nullable    = false
}

variable "disk_image_uri" {
    description = "The URI of the custom image. This should point to an image file in a GCS bucket" 
    type        = string
    nullable    = false
}



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

variable "vpc_name" {
    description = "The name of the VPC"
    type        = string
    nullable    = false
}

variable "vpc_description" {
    description = "A short description of the VPC"
    type        = string
    nullable    = false
}

variable "external_subnet_name" {
    description = "The name of the external subnet"
    type        = string
    nullable    = false
}

variable "external_subnet_cidr_range" {
    description = "The IP range of the external subnet in CIDR format"
    type        = string
    nullable    = false
}

variable "internal_subnet_name" {
    description = "The name of the internal subnet"
    type        = string
    nullable    = false
}

variable "internal_subnet_cidr_range" {
    description = "The IP range of the internal subnet in CIDR format"
    type = string
    nullable = false
}

variable "cloud_router_name" {
    description = "The name of the Cloud router"
    type = string
    default = "cloud-router"    
}

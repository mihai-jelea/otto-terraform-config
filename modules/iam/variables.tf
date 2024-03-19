variable "project_id" {
    description = "The ID of the project where the infrastructure will be deployed"
    type        = string
    nullable    = false
}

variable "roles" {
    description = "The roles that will be granted to the service account."
    type        = list(string)  
    default     = []
}
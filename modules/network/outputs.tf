# The created VPC
output "vpc" {
    description = "The VPC Network"
    value = google_compute_network.vpc_network.id
}

# The created external subnet
output "external_subnet" {
    description = "The external subnet where the web app runs"
    value = google_compute_subnetwork.external_subnet.id
}

# The created internal subnet
output "internal_subnet" {
    description = "The internal subnet where the internal applications run (Warehouse, Logistics and BI)"
    value = google_compute_subnetwork.internal_subnet.id
}

# The reserved IP Address
output "web_app_lb_ip" {
    description = "The public static IP address used by the Regional Application Load Balancer fronting the web app MIGs"
    value = google_compute_address.web_app_ip.address
}
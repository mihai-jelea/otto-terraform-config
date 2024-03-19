# Create VPC
resource "google_compute_network" "vpc_network" {
    project                   = var.project_id
    name                      = var.vpc_name
    description               = var.vpc_description
    auto_create_subnetworks   = false
    routing_mode              = "REGIONAL"
}

# Create external subnet
resource "google_compute_subnetwork" "external_subnet" {
    name          = var.external_subnet_name
    ip_cidr_range = var.external_subnet_cidr_range
    region        = var.region
    network       = google_compute_network.vpc_network.id
    # We need this to be able to access Cloud SQL and other Google Cloud services without needing public IPs
    private_ip_google_access = true
}

# Create internal subnet
resource "google_compute_subnetwork" "internal_subnet" {
    name          = var.internal_subnet_name
    ip_cidr_range = var.internal_subnet_cidr_range
    region        = var.region
    network       = google_compute_network.vpc_network.id
    private_ip_google_access = true
}

# Create the NAT ROUTER to allow the instances in the external 
resource "google_compute_router" "cloud_router" {
    name    = var.cloud_router_name
    region  = var.region
    network = google_compute_network.vpc_network.id
}

resource "google_compute_router_nat" "this" {
    name                                = "${var.cloud_router_name}-nat"
    router                              = google_compute_router.cloud_router.name
    region                              = google_compute_router.cloud_router.region
    nat_ip_allocate_option              = "AUTO_ONLY"
    source_subnetwork_ip_ranges_to_nat  = "LIST_OF_SUBNETWORKS"
    # Allow external access only to external subnet
    subnetwork {
        name                                = google_compute_subnetwork.external_subnet.id
        source_ip_ranges_to_nat             = ["ALL_IP_RANGES"]
    }
}

# Reserve IP Address
resource "google_compute_address" "web_app_ip" {
    name         = "web-app-ip"
    address_type = "EXTERNAL"
    network_tier = "STANDARD"
    region       = var.region
}
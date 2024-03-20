# Configure firewall rules

# 1. Allow incoming RDP connections to tagged VMs
resource "google_compute_firewall" "allow_iap_rdp" {
    name        = "allow-iap-rdp"
    network     = google_compute_network.vpc_network.self_link
    project     = var.project_id

    direction   = "INGRESS"
    priority    = 900
    # The source ranges for IAP TCP forwarding
    source_ranges = ["35.235.240.0/20"]

    allow {
        protocol = "tcp"
        ports    = ["3389"]
    }

    # Targeting only VMs that require RDP connections
    target_tags = ["iap-rdp-enabled"]
}

# 2. Allow outgoing TCP connections for tagged VMs to Mailgun IP addresses
resource "google_compute_firewall" "allow_outgoing_tcp_mailgun" {
    name        = "allow-outgoing-tcp-mailgun"
    network     = google_compute_network.vpc_network.self_link
    project     = var.project_id

    direction   = "EGRESS"
    priority    = 9000

    destination_ranges = [
        "166.78.71.146",
        "23.253.183.59",
        "69.72.45.59",
        "69.72.45.60",
        "69.72.38.129",
        "69.72.38.253",
        "69.72.38.86",
        "69.72.45.19",
        "69.72.45.45",
        "146.20.112.28",
        "146.20.112.29",
        "161.38.198.122",
        "161.38.198.132",
        "161.38.198.50",
    ]

    allow {
        protocol = "tcp"
        ports    = ["443"]
    }

    # Targeting Web App VMs
    target_tags = ["web-app"]
}


# 3. Allow incoming TCP connections to tagged VMs for health-checks
resource "google_compute_firewall" "allow_health_check" {
    name        = "allow-health-check"
    network     = google_compute_network.vpc_network.self_link
    project     = var.project_id

    direction   = "INGRESS"
    priority    = 900
    # The source ranges for Google's health check services
    source_ranges = ["35.191.0.0/16", "130.211.0.0/22"]

    allow {
        protocol = "tcp"
        ports    = ["80"]
    }

    # Targeting only VMs that are part of MIGs
    target_tags = ["lb-mig-backend"]
}


# 4. Allow incoming TCP connections to tagged VMs from LB proxies
resource "google_compute_firewall" "fw_allow_proxies" {
    name        = "fw-allow-proxies"
    network     = google_compute_network.vpc_network.self_link
    project     = var.project_id

    direction   = "INGRESS"
    priority    = 900
    # The source ranges for Google's health check services
    source_ranges = ["10.129.0.0/23"]

    allow {
        protocol = "tcp"
        ports    = ["80, 443, 8080"]
    }

    # Targeting only VMs that are part of MIGs
    target_tags = ["lb-mig-backend"]
}
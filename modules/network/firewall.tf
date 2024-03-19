# Configure firewall rules
# 1. Deny all incoming connections
resource "google_compute_firewall" "deny_all_incoming" {
    name            = "deny_all_incoming"
    network         = google_compute_network.vpc_network.self_link
    project         = var.project_id

    direction       = "INGRESS"
    priority        = 1000
    source_ranges   = ["0.0.0.0/0"]

    # Deny all inbound traffic on all ports
    deny {
        protocol        = "all"
    }
}

# 2. Deny all outgoing connections
resource "google_compute_firewall" "deny_all_outgoing" {
    name        = "deny_all_outgoing"
    network     = google_compute_network.vpc_network.self_link
    project     = var.project_id

    direction   = "EGRESS"
    priority    = 1000
    destination_ranges = ["0.0.0.0/0"]

    # Deny all outbound traffic on all ports
    deny {
        protocol = "all"
    }
}

# 3. Allow incoming RDP connections to tagged VMs
resource "google_compute_firewall" "allow_iap_rdp" {
    name        = "allow_iap_rdp"
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

# 4. Allow outgoing TCP connections for tagged VMs to Mailgun IP addresses
resource "google_compute_firewall" "allow_outgoing_tcp_mailgun" {
    name        = "allow_outgoing_tcp_mailgun"
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


# 5. Allow incoming TCP connections to tagged VMs for health-checks
resource "google_compute_firewall" "allow_health_check" {
    name        = "allow_health_check"
    network     = google_compute_network.vpc_network.self_link
    project     = var.project_id

    direction   = "INGRESS"
    priority    = 900
    # The source ranges for Google's health check services
    source_ranges = ["35.191.0.0/16", "130.211.0.0/22"]

    allow {
        protocol = "tcp"
        ports    = ["80, 443"]
    }

    # Targeting only VMs that are part of MIGs
    target_tags = ["lb-mig-backend"]
}


# 5. Allow incoming TCP connections to tagged VMs from LB proxies
resource "google_compute_firewall" "fw_allow_proxies" {
    name        = "fw_allow_proxies"
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
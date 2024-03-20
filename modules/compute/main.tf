# Create a disk image with all the necessary configs for the web app to run
# It will be used by the instance template below
resource "google_compute_image" "web_app_disk_image" {
    name        = "web_app_disk_image"
    description = "This disk image is used by web app MIG instance template"
    project     = var.project_id

    raw_disk {
        source = var.disk_image_uri
    }
}

# Create the instance template that will be used by the MIGs
resource "google_compute_instance_template" "web_app" {
    name            = var.mig_template_name
    machine_type    = var.web_app_machine_type
    region          = var.region   

    # Set networking to external subnet
    network_interface {
        access_config {
            network_tier = "STANDARD"
        }
        network     = module.network.vpc
        subnetwork  = module.network.external_subnet
    }

    # Configure the disk to use the custom_image we created above
    disk {
        auto_delete  = true
        boot         = true
        device_name  = "persistent-disk-0"
        mode         = "READ_WRITE"
        disk_size_gb = var.web_app_disk_size
        source_image = google_compute_image.web_app_disk_image.self_link
        type         = "PERSISTENT"
    }
    
    scheduling {
        automatic_restart   = true
        on_host_maintenance = "MIGRATE"
        provisioning_model  = "STANDARD"
    }

    # Assign specific Service Account
    service_account {
        email  = module.iam.web_app_sa.email
        scopes = ["https://www.googleapis.com/auth/devstorage.read_only", "https://www.googleapis.com/auth/logging.write", "https://www.googleapis.com/auth/monitoring.write", "https://www.googleapis.com/auth/pubsub", "https://www.googleapis.com/auth/service.management.readonly", "https://www.googleapis.com/auth/servicecontrol", "https://www.googleapis.com/auth/trace.append"]
    }

    # Add required tags for networking purposes
    tags = ["lb-mig-backend", "web-app"]    
}

# Create MIG in zone a
resource "google_compute_instance_group_manager" "web_app_mig1" {
    name = "web-app-mig1"
    zone = "${var.region}-a"
    named_port {
        name = "http"
        port = 80
    }
    version {
        instance_template = google_compute_instance_template.web_app.id
        name              = "primary"
    }
    base_instance_name = "web-app-vm"
    target_size        = 2
}

# Create MIG in zone b
resource "google_compute_instance_group_manager" "web_app_mig2" {
    name = "web-app-mig2"
    zone = "${var.region}-b"
    named_port {
        name = "http"
        port = 80
    }
    version {
        instance_template = google_compute_instance_template.web_app.id
        name              = "primary"
    }
    base_instance_name = "web-app-vm"
    target_size        = 2
}

# Create Health Check for web app MIG
resource "google_compute_region_health_check" "web_app_mig_l7_basic_check" {
    name               = "web-app-mig-l7-basic-check"
    check_interval_sec = 5
    healthy_threshold  = 2
    http_health_check {
        port_specification = "USE_SERVING_PORT"
        proxy_header       = "NONE"
        request_path       = "/"
    }
    region              = var.region
    timeout_sec         = 5
    unhealthy_threshold = 2
}

# Create a backend service for the MIG
resource "google_compute_region_backend_service" "backend_mig" {
    name                  = "backend-mig"
    region                = var.region
    load_balancing_scheme = "EXTERNAL_MANAGED"
    health_checks         = [google_compute_region_health_check.web_app_mig_l7_basic_check.id]
    protocol              = "HTTP"
    session_affinity      = "NONE"
    timeout_sec           = 30
    # Add MIG1 as backend service
    backend {
        group           = google_compute_instance_group_manager.web_app_mig1.instance_group
        balancing_mode  = "UTILIZATION"
        capacity_scaler = 1.0
    }
    # Add MIG2 as backend service
    backend {
        group           = google_compute_instance_group_manager.web_app_mig2.instance_group
        balancing_mode  = "UTILIZATION"
        capacity_scaler = 1.0
    }
}

# Create URL Map
resource "google_compute_region_url_map" "web_app_url_map" {
    name            = "web-app-url-map"
    region          = var.region
    default_service = google_compute_region_backend_service.backend_mig.self_link
}

# Create Google-managed SSL certificate
resource "google_compute_managed_ssl_certificate" "web_app_lb_cert" {
  name = "web-app-lb-cert"

  managed {
    domains = ["otto.nl"]
  }
}

# Create HTTP Proxy
resource "google_compute_region_target_https_proxy" "web_app_http_proxy" {
    name                = "web-app-http-proxy"
    region              = var.region
    url_map             = google_compute_region_url_map.web_app_url_map.id
    ssl_certificates    = [google_compute_managed_ssl_certificate.web_app_lb_cert.self_link]
}

# Create Forwarding Rule for HTTPS traffic
resource "google_compute_forwarding_rule" "web_app_forwarding" {
    name       = "web-app-forwarding"
    provider   = google-beta
    depends_on = [google_compute_subnetwork.proxy_only]
    region     = var.region

    ip_protocol           = "TCP"
    load_balancing_scheme = "EXTERNAL_MANAGED"
    port_range            = "443"
    target                = google_compute_region_target_https_proxy.web_app_http_proxy.id
    network               = module.network.vpc
    ip_address            = module.network.web_app_lb_ip
    network_tier          = "STANDARD"
}
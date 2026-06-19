resource "google_compute_network" "spoke" {
  name                    = "${var.env}-vpc"
  project                 = var.project_id
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
}

resource "google_compute_subnetwork" "spoke" {
  name                     = "${var.env}-subnet"
  project                  = var.project_id
  region                   = var.region
  network                  = google_compute_network.spoke.id
  ip_cidr_range            = var.subnet_cidr
  private_ip_google_access = true

  secondary_ip_range {
    range_name    = "pods"
    ip_cidr_range = var.pods_cidr
  }

  secondary_ip_range {
    range_name    = "services"
    ip_cidr_range = var.services_cidr
  }
}

resource "google_compute_firewall" "spoke_deny_all" {
  name      = "${var.env}-deny-all-ingress"
  project   = var.project_id
  network   = google_compute_network.spoke.name
  direction = "INGRESS"
  priority  = 65534

  deny {
    protocol = "all"
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "spoke_allow_internal" {
  name      = "${var.env}-allow-internal"
  project   = var.project_id
  network   = google_compute_network.spoke.name
  direction = "INGRESS"
  priority  = 1000

  allow {
    protocol = "tcp"
  }
  allow {
    protocol = "udp"
  }
  allow {
    protocol = "icmp"
  }

  source_ranges = [var.subnet_cidr, var.pods_cidr]
}

resource "google_compute_firewall" "spoke_allow_from_hub" {
  name      = "${var.env}-allow-from-hub"
  project   = var.project_id
  network   = google_compute_network.spoke.name
  direction = "INGRESS"
  priority  = 900

  allow {
    protocol = "tcp"
  }
  allow {
    protocol = "icmp"
  }

  source_ranges = ["10.0.0.0/24"]
}


resource "google_compute_firewall" "spoke_allow_iap_ssh" {
  name      = "${var.env}-allow-iap-ssh"
  project   = var.project_id
  network   = google_compute_network.spoke.name
  direction = "INGRESS"
  priority  = 800

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["35.235.240.0/20"]
}

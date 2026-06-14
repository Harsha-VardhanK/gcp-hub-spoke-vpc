resource "google_compute_network" "hub" {
  name                    = "hub-vpc"
  project                 = var.project_id
  auto_create_subnetworks = false
  routing_mode            = "GLOBAL"
}

resource "google_compute_subnetwork" "hub" {
  name                     = "hub-subnet"
  project                  = var.project_id
  region                   = var.region
  network                  = google_compute_network.hub.id
  ip_cidr_range            = var.subnet_cidr
  private_ip_google_access = true
}

resource "google_compute_router" "hub" {
  name    = "hub-router"
  project = var.project_id
  region  = var.region
  network = google_compute_network.hub.id
}

resource "google_compute_router_nat" "hub" {
  name                               = "hub-nat"
  project                            = var.project_id
  router                             = google_compute_router.hub.name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

resource "google_compute_firewall" "hub_deny_all" {
  name      = "hub-deny-all-ingress"
  project   = var.project_id
  network   = google_compute_network.hub.name
  direction = "INGRESS"
  priority  = 65534

  deny {
    protocol = "all"
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "hub_allow_internal" {
  name      = "hub-allow-internal"
  project   = var.project_id
  network   = google_compute_network.hub.name
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

  source_ranges = ["10.0.0.0/8"]
}


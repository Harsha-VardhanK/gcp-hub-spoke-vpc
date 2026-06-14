# Peering from hub → spoke
resource "google_compute_network_peering" "hub_to_spoke" {
  name         = "hub-to-${var.env}"
  network      = var.hub_vpc_self_link
  peer_network = var.spoke_vpc_self_link

  export_custom_routes = true
  import_custom_routes = false
}

# Peering from spoke → hub
resource "google_compute_network_peering" "spoke_to_hub" {
  name         = "${var.env}-to-hub"
  network      = var.spoke_vpc_self_link
  peer_network = var.hub_vpc_self_link

  export_custom_routes = false
  import_custom_routes = true

  depends_on = [google_compute_network_peering.hub_to_spoke]
}
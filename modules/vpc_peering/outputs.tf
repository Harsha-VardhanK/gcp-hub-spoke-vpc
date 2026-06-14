output "hub_to_spoke_peering_name" {
  value = google_compute_network_peering.hub_to_spoke.name
}

output "spoke_to_hub_peering_name" {
  value = google_compute_network_peering.spoke_to_hub.name
}

output "peering_state" {
  value = google_compute_network_peering.hub_to_spoke.state
}
output "vpc_id" {
  value = google_compute_network.hub.id
}

output "vpc_self_link" {
  value = google_compute_network.hub.self_link
}

output "vpc_name" {
  value = google_compute_network.hub.name
}

output "subnet_self_link" {
  value = google_compute_subnetwork.hub.self_link
}

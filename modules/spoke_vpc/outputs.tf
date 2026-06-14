output "vpc_id" {
  value = google_compute_network.spoke.id
}

output "vpc_self_link" {
  value = google_compute_network.spoke.self_link
}

output "vpc_name" {
  value = google_compute_network.spoke.name
}

output "subnet_self_link" {
  value = google_compute_subnetwork.spoke.self_link
}

output "subnet_name" {
  value = google_compute_subnetwork.spoke.name
}
# Networks and subnets for GKE
# VPC
resource "google_compute_network" "vpc" {
  name                    = "${var.project_id}-vpc"
  auto_create_subnetworks = "false"
}

# Subnets
resource "google_compute_subnetwork" "subnet" {
  name          = "${var.project_id}-subnet"
  region        = var.region
  network       = google_compute_network.vpc.name
  ip_cidr_range = var.ip_cidr_range
}

# Return data
output "Network_name" {
  value       = google_compute_network.vpc.name
  description = "Network name"
}

output "Network_region" {
  value       = google_compute_subnetwork.subnet.region
  description = "Network region"
}

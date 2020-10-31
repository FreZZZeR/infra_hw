#Cinfig
terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "3.45.0"
    }
  }
}
#
#Providers
provider "google" {
  credentials = file(var.creds)
  project     = var.project_id
  region      = var.region
  zone        = var.zone
}
#
# Networks and subnets
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

# GKE cluster
resource "google_container_cluster" "primary" {
  name                     = "${var.project_id}-gke"
  location                 = var.zone
  remove_default_node_pool = true
  initial_node_count       = 1
  network                  = google_compute_network.vpc.name
  subnetwork               = google_compute_subnetwork.subnet.name

}
# Return cluster data
output "GKE_Cluster_location" {
  value       = google_container_cluster.primary.location
  description = "GKE Cluster location"
}
output "GKE_Cluster_name" {
  value       = google_container_cluster.primary.name
  description = "GKE Cluster name"
}


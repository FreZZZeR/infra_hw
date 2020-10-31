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


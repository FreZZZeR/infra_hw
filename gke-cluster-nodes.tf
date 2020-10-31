# Configuring GKE CLuster nodes
resource "google_container_node_pool" "primary_nodes" {
  name       = "${google_container_cluster.primary.name}-node-pool"
  location   = var.zone
  cluster    = google_container_cluster.primary.name
  node_count = var.gke_number_nodes
  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
    labels = {
      env = var.project_id
    }
    machine_type = var.machine_type
    tags         = ["gke-node", "${var.project_id}-gke"]
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}

# Return cluster nodes pool data
output "GKE_Cluster_nodes_pool_location" {
  value       = google_container_node_pool.primary_nodes.location
  description = "GKE Cluster nodes pool location"
}

output "GKE_Cluster_nodes_pool_nodes_count" {
  value       = google_container_node_pool.primary_nodes.node_count
  description = "GKE Cluster nodes pool nodes count"
}


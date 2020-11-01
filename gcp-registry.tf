#GCP Registry
resource "google_container_registry" "registry" {
  project  = var.project_id
  location = var.registry_location
}

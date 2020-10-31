#Configuration terraform
terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "3.45.0"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
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
provider "kubernetes" {
  load_config_file       = false

  host                   = google_container_cluster.primary.endpoint
  token                  = data.google_client_config.provider.access_token
  cluster_ca_certificate = base64decode(google_container_cluster.primary.master_auth.0.cluster_ca_certificate)
}

# Retrieve an access token as the Terraform runner
data "google_client_config" "provider" {}
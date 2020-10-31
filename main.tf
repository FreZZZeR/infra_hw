#Configuration terraform
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

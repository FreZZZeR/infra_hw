# Declarating some variables
#
variable "creds" {
  description = "GCP credential file path"
  default = "~/gcp-credential.json"
}
variable "project_id" {
  description = "Project ID"
  default = "My First Project"
}
variable "region" {
  description = "GKE region"
  default = "us-central1"
}
variable "zone" {
  description = "GKE zone"
  default = "us-central1-a"
}
variable "ip_cidr_range" {
  description = "Subnet ip range"
  default = "10.10.10.0/24"
}
variable "gke_number_nodes" {
  description = "Nodes count for pool of GKE cluster"
  default = "3"
}
variable "machine_type" {
  description = "GKE nodes machine type"
  default = "e2-standard-2"
}
variable "prod_ns" {
  description = "Production namespace name"
  default = "Production"
}
variable "test_ns" {
  description = "Test namespace name"
  default = "Testing"
}
variable "dev_ns" {
  description = "Developers namespace name"
  default = "Developing"
}
variable "registry_location" {
  description = "GCP Registry location"
  default = "US"
}

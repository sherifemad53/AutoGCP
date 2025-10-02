# vpc module

resource "google_compute_network" "vpc" {
  name                    = var.vpc_name
  project = var.project
  auto_create_subnetworks = false
}



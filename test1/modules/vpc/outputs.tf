# Outputs for vpc module
output "vpc_name" {
  value = google_compute_network.vpc.name
}

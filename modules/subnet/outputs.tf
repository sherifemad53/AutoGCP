# Outputs for subnet module

output "subnet_ids" {
  value = { for name, subnet in google_compute_subnetwork.subnet : name => subnet.id }
}


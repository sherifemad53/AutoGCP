# subnet module

resource "google_compute_subnetwork" "subnet" {
  for_each      = { for s in var.subnets : s.name => s }
  name          = each.value.name
  ip_cidr_range = each.value.cidr
  region        = each.value.region
  network       = var.vpc_name
  project       = var.project
}



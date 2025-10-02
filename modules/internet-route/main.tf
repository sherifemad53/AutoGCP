# internet-route module

resource "google_compute_route" "default_internet" {
  name             = "default-internet-route"
  network          = var.vpc_name
  dest_range       = "0.0.0.0/0"
  priority         = 1000
  next_hop_gateway = true
}

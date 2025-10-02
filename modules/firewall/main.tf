# firewall module

# Allow SSH
resource "google_compute_firewall" "ssh" {
  name    = "allow-ssh"
  network = var.vpc_name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

target_tags = [ var.ssh_target_tag]

  source_ranges = var.allow_ssh_source
}

# Allow HTTP/HTTPS
resource "google_compute_firewall" "web" {
  name    = "allow-web"
  network = var.vpc_name

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }
    target_tags = [ var.http_target_tag]
  source_ranges = var.allow_http_https_source
}

# Allow internal traffic within VPC
resource "google_compute_firewall" "internal" {
  name    = "allow-internal"
  network = var.vpc_name

  allow {
    protocol = "all"
  }

  source_ranges = ["10.0.0.0/8"]
}

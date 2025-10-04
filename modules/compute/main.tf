# compute module

resource "google_compute_instance" "vm" {
  for_each      = { for vm in var.vms : vm.vm_name => vm }
  name = each.value.vm_name
  machine_type = each.value.machine_type
  zone = each.value.zone
  # tags = each.value.tags

  
  
  project = var.project

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    subnetwork   = each.value.subnet
    access_config {}
  }
}




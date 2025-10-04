# Variables for compute module

# variable "vm_name" { 
#     type = string 
#     default = "vm-test"
# }

# variable "machine_type" { type = string }
# variable "zone" { type = string }
# variable "subnet" { type = string }
variable "project" {
  type = string
}

variable "vms" {
  type = list(object({
    vm_name = string
    machine_type = string
    zone = string
    subnet = string
  }
  ))
}
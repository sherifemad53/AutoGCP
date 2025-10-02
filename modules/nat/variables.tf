# Variables for nat module

variable "nat_name" {
  type        = string
  description = "Name tag for the nat"
}

variable "region" { type = string }
variable "router_name" { type = string }


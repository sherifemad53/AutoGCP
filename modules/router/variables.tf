# Variables for router module

variable "router_name" {
  type        = string
  description = "Name tag for the router"
}

variable "region" { type = string }
variable "vpc_name" { type = string }

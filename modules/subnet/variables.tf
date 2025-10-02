# Variables for subnet module
variable "subnet_name" { type = string }
variable "region"      { type = string }
variable "vpc_name"    { type = string }
variable "cidr_range" { 
    type = string
    default = "10.0.0.0/16"
}
variable "project" {
  type = string
}
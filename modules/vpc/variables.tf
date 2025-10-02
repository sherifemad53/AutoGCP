# Variables for vpc module

variable "vpc_name" {
  type        = string
  description = "Name tag for the vpc"
}

variable "tags" {
  type        = map(string)
  description = "Additional tags"
  default     = {}
}

variable "project" {
  type = string
  
}

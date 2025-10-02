# Variables for project module

variable "project_id" {
  type        = string
  description = "The new project ID (must be unique)"
}

variable "project_name" {
  type        = string
  description = "Display name for the project"
}

variable "org_id" {
  type        = string
  description = "The organization ID where the project will be created"
}

variable "billing_account" {
  type        = string
  description = "Billing account ID to associate with the project"
}

variable "labels" {
  type = map(string)
  default = {
    "enviroment" = "dev"
  }
}
terraform {
  required_version = ">= 1.5.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
  }
}

provider "google" {
  credentials = file(var.credentials_file)
  # region  = var.region
  # project = var.project_id
  # zone    = var.zone
}

module "project" {
  source          = "./modules/project"
  project_id      = var.project_id
  project_name    = var.project_name
  org_id          = var.org_id
  billing_account = var.billing_account
  labels          = var.labels
}

# VPC
module "vpc" {
  source     = "./modules/vpc"
  vpc_name   = var.vpc_name
}

# Subnet
module "subnet" {
  source      = "./modules/subnet"
  vpc_name    = module.vpc.vpc_name
  subnet_name = var.subnet_name
  region      = var.region
  cidr_range  = var.cidr_range
}

# Storage Bucket
module "bucket" {
  source     = "./modules/bucket"
  bucket_name = "${var.project_id}-bucket"
  region      = var.region
}

# Compute VM
module "compute" {
  source       = "./modules/compute"
  vm_name      = var.vm_name
  zone         = var.zone
  machine_type = var.machine_type
  subnet       = module.subnet.subnet_name
}

# IAM Service Account
module "iam" {
  source           = "./modules/iam"
  service_account  = "terraform"
  project_id       = var.project_id
}

# Router
module "router" {
  source    = "./modules/router"
  router_name = "tf-router"
  region      = var.region
  vpc_name    = module.vpc.vpc_name
}

# NAT
module "nat" {
  source      = "./modules/nat"
  nat_name    = "tf-nat"
  region      = var.region
  router_name = module.router.router_name
}

# Internet Route (for public subnet)
module "internet_route" {
  source   = "./modules/internet-route"
  vpc_name = module.vpc.vpc_name
  region   = var.region
}

# # SQL Database
# module "sql" {
#   source           = "./modules/sql"
#   db_instance_name = "tf-sql-instance"
#   region           = var.region
# }
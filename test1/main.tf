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
}


module "project" {
  source = "./modules/project"
  project_id = var.project_project_id
  project_name = var.project_project_name
  org_id = var.project_org_id
  billing_account = var.project_billing_account
  labels = var.project_labels
}

module "vpc" {
  source = "./modules/vpc"
  vpc_name = var.vpc_vpc_name
  project = module.project.project_id
}

module "subnet" {
  source = "./modules/subnet"
  subnet_name = var.subnet_subnet_name
  region = var.subnet_region
  vpc_name = var.subnet_vpc_name
  cidr_range = var.subnet_cidr_range
  project = module.project.project_id
}

module "bucket" {
  source = "./modules/bucket"
  bucket_name = var.bucket_bucket_name
  region = var.bucket_region
  project = module.project.project_id
}

module "compute" {
  source = "./modules/compute"
  vm_name = var.compute_vm_name
  machine_type = var.compute_machine_type
  zone = var.compute_zone
  subnet = var.compute_subnet
  project = module.project.project_id
}

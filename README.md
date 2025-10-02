# AutoGCP – YAML-driven Terraform for Google Cloud

This repository provides a Terraform-based framework to provision common Google Cloud (GCP) resources, driven by a simple YAML configuration and helper scripts. Define your project and modules once in YAML, then generate a ready-to-run Terraform project and plan/apply it automatically.

## Features
- Reusable GCP Terraform modules: `project`, `vpc`, `subnet`, `bucket`, `compute`, `iam`, `router`, `nat`, `internet-route` (and placeholders for more)
- YAML-driven project generation via `scripts/deploy.py`
- Supports planning or applying in a generated per-config directory
- Optional `destroy.py` to tear down resources for a given config

## Repository Structure

```
/ (repo root)
├── main.tf                 # Example root stack wiring modules together (GCP)
├── variables.tf            # Variables consumed by the root stack
├── terraform.tfvars        # Example variable values for the root stack
├── modules/                # Reusable Terraform modules (GCP)
├── configs/
│   └── test1.yaml          # Example YAML configuration
├── scripts/
│   ├── deploy.py           # Generate per-config Terraform and run plan/apply
│   └── destroy.py          # Destroy generated per-config Terraform
├── test1/                  # Example generated project from configs/test1.yaml
│   ├── main.tf
│   ├── variables.tf
│   └── terraform.tfvars.json
└── app-requirenemts.md     # Project requirements and context (GCP brief)
```

## Prerequisites
- Terraform >= 1.5
- Python 3.9+
- GCP credentials via a service account JSON:
  - Set environment variable `GOOGLE_APPLICATION_CREDENTIALS=/absolute/path/to/key.json`
  - Ensure the service account has permissions to create projects and related resources

## Quick Start – Root Stack (optional)
If you prefer to run directly from the root stack:
1. Review and update `terraform.tfvars` with your `project_id`, `project_name`, `org_id`, `billing_account`, regions, etc.
2. Initialize providers and modules:
   ```bash
   terraform init
   ```
3. Review the plan:
   ```bash
   terraform plan
   ```
4. Apply:
   ```bash
   terraform apply
   ```

## YAML-driven Generation (scripts/deploy.py)
The generator reads a YAML config and creates a project directory named after the YAML file (without extension). It writes:
- `main.tf` and `variables.tf` with module wiring
- `terraform.tfvars.json` with flattened variables (`var.<module>_<key>`)
Then it runs `terraform init` and `terraform plan` (or `apply` with a flag) in the generated directory.

Example config (`configs/test1.yaml`):
```yaml
project:
  project_id: "dev-intern-poc"
  project_name: "Dev intern PoC"
  org_id: "YOUR_ORG_ID"
  billing_account: "XXXXXX-XXXXXX-XXXXXX"
  labels:
    owner: intern
    environment: test

modules:
  vpc:
    vpc_name: "my-vpc"
  subnet:
    subnet_name: "my-subnet"
    region: "us-central1"
    vpc_name: module.vpc.vpc_name
    cidr_range: "10.0.1.0/24"
  bucket:
    bucket_name: "my-bucket"
    region: "us-central1"
  compute:
    vm_name: "my-vm"
    machine_type: "e2-micro"
    zone: module.project.zone
    subnet: module.subnet.subnet_name
```

Run the generator:
```bash
python scripts/deploy.py configs/test1.yaml
```
- Add `--apply` to run `terraform apply -auto-approve` instead of `plan`.
- The script validates `GOOGLE_APPLICATION_CREDENTIALS` is set and the file exists.

This creates a folder `test1/` with Terraform files and runs Terraform commands inside it.

## Destroy Generated Project
To destroy the resources for a given YAML config:
```bash
python scripts/destroy.py configs/test1.yaml
```
This runs `terraform destroy -auto-approve` inside the corresponding generated directory (e.g., `./test1`).

## Notes and Limitations
- Module wiring expects variables flattened to `var.<module>_<key>`; the generator emits these in `variables.tf`.
- Literal Terraform expressions (e.g., `module.vpc.vpc_name`) may need manual review depending on the module’s outputs and relationships.
- Ensure your service account has the required organization and billing permissions to create/link projects and enable APIs.

## Learning Goals
This project demonstrates:
- Structuring reusable Terraform modules on GCP
- YAML-to-Terraform automation using Python
- Repeatable, low-friction project provisioning workflows

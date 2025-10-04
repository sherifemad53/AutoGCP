import os
import sys
import yaml
import json
import argparse
import subprocess
import shutil
from pathlib import Path
from config import MODULE_PATHS


MAIN_HEADER = """terraform {
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

"""

def generate_tf_project(yaml_file):
    with open(yaml_file, "r") as f:
        config = yaml.safe_load(f) or {}

    project_name = Path(yaml_file).stem
    project_dir = Path("./generated-projects/" + project_name)
    project_dir.mkdir(exist_ok=True)

    project_conf = config.get("project") or {}
    modules = config.get("modules", {}) or {}

    print("Generating Terraform project............")

    # ---------------- main.tf ----------------
    main_tf = [MAIN_HEADER]
    variables_tf = []

    # ---- Project module ----
    main_tf.append('module "project" {')
    main_tf.append(f'  source = "{MODULE_PATHS["project"]}"')
    for key, val in project_conf.items():
        main_tf.append(f'  {key} = var.project_{key}')
        variables_tf.append(f'variable "project_{key}" {{}}')
    main_tf.append("}\n")

    copy_or_create_module(project_dir / "modules" / "project", project_conf, MODULE_PATHS["project"])

    # ---- Other modules ----
    for mod_name, mod_conf in modules.items():
        source = MODULE_PATHS.get(mod_name)
        if not source:
            raise ValueError(f"Unknown module '{mod_name}'. Please add it to MODULE_PATHS.")

        main_tf.append(f'module "{mod_name}" {{')
        main_tf.append(f'  source = "{source}"')

        for key in mod_conf.keys():
            main_tf.append(f'  {key} = var.{mod_name}_{key}')
            variables_tf.append(f'variable "{mod_name}_{key}" {{}}')

            # inject project references
        main_tf.append('  project = module.project.project_id')
            # main_tf.append('  region     = module.project.region')
            # main_tf.append('  zone       = module.project.zone')

        main_tf.append("}\n")

        copy_or_create_module(project_dir / "modules" / mod_name, mod_conf, source)

    # Write files
    (project_dir / "main.tf").write_text("\n".join(main_tf))
    (project_dir / "variables.tf").write_text("\n".join(variables_tf))

    # Flatten both project + other modules into tfvars.json
    flat_vars = flatten_vars({"project": project_conf, **modules})
    (project_dir / "terraform.tfvars.json").write_text(json.dumps(flat_vars, indent=2))

    print(f"DONE Project '{project_name}' generated at {project_dir.absolute()}")
    return project_dir

def flatten_vars(modules: dict):
    """Flatten module variables to match var.<module>_<key> style"""
    flat = {}
    for mod, conf in modules.items():
        for key, val in conf.items():
            if key != "source":
                flat[f"{mod}_{key}"] = val
    return flat



def copy_or_create_module(target_dir: Path, mod_conf, source: str):
    """Copy module if exists, else create skeleton"""
    source_path = Path(source)

    if source_path.exists():
        if target_dir.exists():
            shutil.rmtree(target_dir)
        shutil.copytree(source_path, target_dir)
    else:
        target_dir.mkdir(parents=True, exist_ok=True)
        # main.tf placeholder
        (target_dir / "main.tf").write_text(
            f"""# {target_dir.name} module
# Define GCP resources for {target_dir.name} here
"""
        )
        # variables.tf
        lines = []
        for key in mod_conf:
            lines.append(f'variable "{key}" {{}}')
        (target_dir / "variables.tf").write_text("\n".join(lines) + "\n")

        # outputs.tf
        (target_dir / "outputs.tf").write_text(
            f"""# Outputs for {target_dir.name} module
# Example:
# output "{target_dir.name}_id" {{
#   value = google_<resource>.this.id
# }}
"""
        )

def check_gcp_credentials():
    """Check if GOOGLE_APPLICATION_CREDENTIALS env var exists"""
    cred_file = os.getenv("GOOGLE_APPLICATION_CREDENTIALS")
    print(f"Using GCP credentials from: {cred_file}")
    if not cred_file or not Path(cred_file).exists():
        print("Error: GCP credentials not found. Set GOOGLE_APPLICATION_CREDENTIALS to your service account JSON.")
        sys.exit(1)



def run_terraform_commands(project_dir, do_apply=False):
    """Run terraform init and plan/apply in the generated project directory"""
    cwd = os.getcwd()
    try:
        os.chdir(project_dir)
        subprocess.run(["terraform", "init"], check=True)
        if do_apply:
            subprocess.run(["terraform", "apply", "-auto-approve"], check=True)
        else:
            subprocess.run(["terraform", "plan"], check=True)
    finally:
        os.chdir(cwd)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Generate a Terraform project from YAML and run Terraform.")
    parser.add_argument("yaml", help="Path to YAML config file")
    parser.add_argument("--apply", action="store_true", help="Run 'terraform apply -auto-approve' instead of 'plan'")
    args = parser.parse_args()

    check_gcp_credentials()
    yaml_file = args.yaml
    project_dir = generate_tf_project(yaml_file)
    run_terraform_commands(project_dir, do_apply=args.apply)

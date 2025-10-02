# iam module

resource "google_service_account" "sa" {
  account_id   = var.service_account
  display_name = "Terraform Service Account"
}



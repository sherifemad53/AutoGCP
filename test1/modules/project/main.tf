# project module

resource "google_project" "project" {
  project_id      = var.project_id
  name            = var.project_name
  org_id          = var.org_id
  billing_account = var.billing_account
  labels          = var.labels
}



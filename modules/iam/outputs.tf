# Outputs for iam module

output "service_account_email" {
  value = google_service_account.sa.email
}

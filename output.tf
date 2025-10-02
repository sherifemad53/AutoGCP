output "bucket_name" {
  value = module.bucket.bucket_name
}

output "vm_ip" {
  value = module.compute.vm_ip
}

output "service_account_email" {
  value = module.iam.service_account_email
}

output "storage_bucket_name" {
  value = google_storage_bucket.terraform.name
}

output "service_account_name" {
  value = module.service_accounts.service_account.id
}

output "service_account_json_key" {
  value = local_file.service_account.filename
}

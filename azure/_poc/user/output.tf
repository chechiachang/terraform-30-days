output "user_principal_name" {
  value       = azuread_user.terraform.user_principal_name
  description = "The username of aduser/terraform."
}

output "password" {
  value       = random_password.terraform.result
  description = "The password of aduser/terraform."
  sensitive   = true
}

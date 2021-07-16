resource "random_password" "terraform" {
  length           = 16
  special          = true
  override_special = "_%@"
}

resource "azuread_user" "terraform" {
  user_principal_name = "terraform@chechia.net" # Need valified domain on Azure AD
  display_name        = "Terraform Runner"
  mail_nickname       = "terraform"
  password            = random_password.terraform.result
}

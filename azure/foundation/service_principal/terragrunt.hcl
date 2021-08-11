# TERRAGRUNT CONFIGURATION

terraform {
  source = "../../..//azure/modules/azuread_service_principal"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  service_principal_name               = "terraform-30-days"
  enable_service_principal_certificate = true
  # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/service_principal_client_certificate)
  certificate_path                     = "/Users/che-chia/.ssh/terraform-30-days.crt"
  password_rotation_in_years           = 1

  # Adding roles to service principal
  # The principle of least privilege
  role_definition_names = [
    "Contributor",
    "Owner" # try Privilege escalation
  ]
}

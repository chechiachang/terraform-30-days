# TERRAGRUNT CONFIGURATION

terraform {
  source = "../../../..//azure/modules/terraform_backend"
}

# dependency cycle
#include {
#  path = "${find_in_parent_folders()}"
#}

generate "provider" {
  path = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
provider "azurerm" {
  features {}
}
EOF
}

inputs = {
  resource_group_name = "terraform-30-days"
  location            = "southeastasia" # Or use japaneast
}

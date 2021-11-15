# TERRAGRUNT CONFIGURATION

terraform {
  source = "../../../..//azure/modules/container_registry"
}

include {
  path = "${find_in_parent_folders()}"
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "azurerm" {
  features {}
}
EOF
}

inputs = {
  registry_name                 = "chechiasoutheastasia"
  location                      = "southeastasia"
  public_network_access_enabled = true
}

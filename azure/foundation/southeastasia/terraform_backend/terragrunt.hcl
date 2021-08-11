# TERRAGRUNT CONFIGURATION

terraform {
  source = "../../../..//azure/modules/terraform_backend"
}

# dependency cycle: terraform_backend is provisioned before all terragrunt usage. There is no terragrunt.hcl at that time.
#include {
#  path = find_in_parent_folders()
#}

inputs = {
  resource_group_name = "terraform-30-days"
  location            = "southeastasia" # Or use japaneast
}

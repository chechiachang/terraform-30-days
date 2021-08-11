# TERRAGRUNT CONFIGURATION

terraform {
  source = "../../..//azure/modules/compute_network"
}

# use terragrunt function to include .hcl file
# in this case, will find azure/terragrunt.hcl
include {
  path = find_in_parent_folders()
}

inputs = {
  address_space = "10.2.0.0/16"

  subnet_prefixes = [
    "10.2.1.0/24",
    "10.2.2.0/24",
    "10.2.3.0/24",
  ]

  subnet_names = [
    "dev-1",
    "dev-2",
    "dev-3",
  ]

  tags = {
    environment = "foundation"
  }
}

# TERRAGRUNT CONFIGURATION

terraform {
  source = "../../../../../..//azure/modules/vault_singleton"
}

include {
  path = find_in_parent_folders()
}

locals {
  common = yamldecode(file(find_in_parent_folders("common_vars.yaml")))
}

# https://terragrunt.gruntwork.io/docs/reference/config-blocks-and-attributes/#dependency
dependency "network" {
  config_path = find_in_parent_folders("azure/foundation/compute_network")
}

inputs = {
  resource_group_name = local.common.resource_group_name
  location            = local.common.location
  environment         = local.common.environment

  vm_hostname  = "vault"
  vm_size      = "Standard_B1s" # azure free plan
  vm_os_simple = "UbuntuServer"

  vnet_subnet_id = dependency.network.outputs.vnet_subnets[0] # dev-1

  remote_port = 8200 # vault
  source_address_prefixes = [
    "123.194.159.122", # my ip
    "10.2.1.0/24"      # dev-1
  ]

  cloudconfig_file = "./cloudconfig.yaml"
}

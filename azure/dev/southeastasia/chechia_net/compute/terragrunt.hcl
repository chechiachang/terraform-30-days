# TERRAGRUNT CONFIGURATION

terraform {
  source = "../../../../..//azure/modules/compute"
}

include {
  path = find_in_parent_folders()
}

locals {
  common = yamldecode(file(find_in_parent_folders("common_vars.yaml")))
}

# https://terragrunt.gruntwork.io/docs/reference/config-blocks-and-attributes/#dependency
dependency "network"{
  config_path = find_in_parent_folders("azure/foundation/compute_network")
}

inputs = {
  environment         = local.common.environment

  vm_hostname         = "chechia-net"
  vm_size             = "Standard_B1s" # azure free plan
  vm_os_simple        = "UbuntuServer"

  vnet_subnet_id      = dependency.network.outputs.vnet_subnets[0] # dev-1
}

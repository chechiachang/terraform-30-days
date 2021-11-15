# TERRAGRUNT CONFIGURATION

terraform {
  source = "../../../../../..//azure/modules/vault_cluster"
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

  name      = "vault"
  sku       = "Standard_DS1_v2" # This is beyond 12 months free quota
  instances = 1

  network = dependency.network.outputs.vnet_name       # acctvnet
  subnet  = dependency.network.outputs.vnet_subnets[2] # dev-3

  # Spot
  priority      = "Spot"
  max_bid_price = "0.16" # > 0.15708

  # os
  source_image_publisher = "canonical"
  source_image_offer     = "0001-com-ubuntu-server-focal"
  source_image_sku       = "20_04-lts-gen2"

  # Security
  ssh_key_file_path = "~/.ssh/chia.pub"
  allowed_ssh_cidr_blocks = [
    "10.0.2.0/24"
  ]

  cloudconfig_file = "./cloudconfig.yaml"
}

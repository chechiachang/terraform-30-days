# https://github.com/Azure/terraform-azurerm-network
module "network" {
  source = "Azure/network/azurerm"

  resource_group_name = var.resource_group_name
  address_space       = var.address_space
  subnet_prefixes     = var.subnet_prefixes
  subnet_names        = var.subnet_names
  tags                = var.tags
}

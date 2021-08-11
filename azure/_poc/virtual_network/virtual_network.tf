locals {
  resource_group_name = "terraform-30-days"
  location            = "southeastasia"
  subnets = {
    base-external = {
      name             = "poc-chechia"
      address_prefixes = ["10.1.2.0/24"]
      # network_security_group_id is depends on ../security_group
      network_security_group_id = "/subscriptions/6fce7237-7e8e-4053-8e7d-ecf8a7c392ce/resourceGroups/terraform-30-days/providers/Microsoft.Network/networkSecurityGroups/poc-chechia"
    }
  }
}

resource "azurerm_virtual_network" "main" {
  name                = "poc-chechia"
  address_space       = ["10.1.0.0/16"]
  location            = local.location
  resource_group_name = local.resource_group_name
}

resource "azurerm_subnet" "main" {
  for_each = local.subnets

  name                 = each.value.name
  resource_group_name  = local.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = each.value.address_prefixes
}

resource "azurerm_subnet_network_security_group_association" "main" {
  for_each = local.subnets

  subnet_id                 = azurerm_subnet.main[each.key].id
  network_security_group_id = each.value.network_security_group_id
}

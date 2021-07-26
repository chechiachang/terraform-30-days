resource "azurerm_network_security_group" "main" {
  name                = local.name
  location            = local.location
  resource_group_name = local.resource_group_name

  tags = {
    environment = local.environment
  }
}

resource "azurerm_network_security_rule" "main" {
  for_each                    = local.rules
  name                        = each.value.name
  priority                    = each.value.priority
  direction                   = each.value.direction
  access                      = each.value.access
  protocol                    = each.value.protocol
  source_port_range           = each.value.source_port_range
  destination_port_range      = each.value.destination_port_range
  source_address_prefix       = each.value.source_address_prefix
  destination_address_prefix  = each.value.destination_address_prefix
  resource_group_name         = local.resource_group_name
  network_security_group_name = local.name
}

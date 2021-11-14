resource "azurerm_network_security_rule" "vault_8200" {
  count = length(var.allowed_vault_cidr_blocks)

  access                      = "Allow"
  destination_address_prefix  = "*"
  destination_port_range      = "8200"
  direction                   = "Inbound"
  name                        = "vault_8200${count.index}"
  network_security_group_name = module.scale_set.security_group_name
  priority                    = 100 + count.index
  protocol                    = "Tcp"
  resource_group_name         = var.resource_group_name
  source_address_prefix       = element(var.allowed_vault_cidr_blocks, count.index)
  source_port_range           = "*"
}

#resource "azurerm_network_security_rule" "vault_internalt_8201" {
#  count = length(var.allowed_vault_internal_cidr_blocks)
#
#  access                      = "Allow"
#  destination_address_prefix  = "*"
#  destination_port_range      = "8201"
#  direction                   = "Inbound"
#  name                        = "vault_internal_8201${count.index}"
#  network_security_group_name = module.scale_set.security_group_name
#  priority                    = 100 + count.index
#  protocol                    = "Tcp"
#  resource_group_name         = var.resource_group_name
#  source_address_prefix       = element(var.allowed_vault_internal_cidr_blocks, count.index)
#  source_port_range           = "*"
#}

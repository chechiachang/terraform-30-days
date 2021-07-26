locals {
  resource_group_name = "terraform-30-days"
  location            = "southeastasia"
  environment         = "poc"
  name                = "poc-chechia"

  rules = {
    homeport22 = {
      access                                     = "Allow"
      description                                = ""
      destination_address_prefix                 = "*"
      destination_address_prefixes               = []
      destination_application_security_group_ids = []
      destination_port_range                     = "22"
      destination_port_ranges                    = []
      direction                                  = "Inbound"
      name                                       = "Port_22"
      priority                                   = 100
      protocol                                   = "*"
      source_address_prefix                      = "17.110.101.57" # home ip to allow ssh
      source_address_prefixes                    = []
      source_application_security_group_ids      = []
      source_port_range                          = "*"
      source_port_ranges                         = []
    }
  }
}

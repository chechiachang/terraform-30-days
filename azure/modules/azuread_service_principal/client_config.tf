# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config
data "azuread_client_config" "current" {}

data "azurerm_client_config" "current" {}

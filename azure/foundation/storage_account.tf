resource "random_id" "storage_account_name" {
  byte_length = 8
}

resource "azurerm_storage_account" "main" {
  #name                     = "tfstate" # Error: This name is taken. Create a unique name or use random id
  name                     = "tfstate${random_id.storage_account_name.hex}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"

  tags = {
    environment = "foundation"
  }
}

resource "azurerm_storage_container" "main" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = "private"
}

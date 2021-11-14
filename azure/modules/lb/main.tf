resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_public_ip" "main" {
  name                = var.name
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = var.public_ip_allocation_method
}

resource "azurerm_lb" "main" {
  name                = var.name
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name

  frontend_ip_configuration {
    name                 = var.name
    public_ip_address_id = azurerm_public_ip.main.id
  }
}

resource "azurerm_lb_backend_address_pool" "main" {
  resource_group_name = azurerm_resource_group.main.name
  loadbalancer_id     = azurerm_lb.main.id
  name                = var.name
}

resource "azurerm_lb_nat_pool" "main" {
  resource_group_name            = azurerm_resource_group.main.name
  name                           = var.name
  loadbalancer_id                = azurerm_lb.main.id
  protocol                       = var.protocol
  frontend_port_start            = var.frontend_port_start
  frontend_port_end              = var.frontend_port_end
  backend_port                   = var.backend_port
  frontend_ip_configuration_name = var.name
}

resource "azurerm_lb_probe" "main" {
  resource_group_name = azurerm_resource_group.main.name
  loadbalancer_id     = azurerm_lb.main.id
  name                = "http-probe"
  protocol            = "Http"
  request_path        = "/health"
  port                = 8200
}

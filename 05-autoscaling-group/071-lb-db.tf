resource "azurerm_public_ip" "db" {
  name                = "db-ip"
  location            = azurerm_resource_group.generic.location
  resource_group_name = azurerm_resource_group.generic.name
  allocation_method   = "Static"
}

resource "azurerm_lb" "db" {
  name                = "db-lb"
  location            = azurerm_resource_group.generic.location
  resource_group_name = azurerm_resource_group.generic.name

  frontend_ip_configuration {
    name                 = "DbPublicIPAddress"
    public_ip_address_id = azurerm_public_ip.db.id
  }
}

resource "azurerm_lb_backend_address_pool" "db" {
  resource_group_name = azurerm_resource_group.generic.name
  name                = "DbBackEndAddressPool"
  loadbalancer_id     = azurerm_lb.db.id
}

resource "azurerm_lb_nat_pool" "db" {
  resource_group_name            = azurerm_resource_group.generic.name
  name                           = "db-nat-pool"
  loadbalancer_id                = azurerm_lb.db.id
  protocol                       = "Tcp"
  frontend_port_start            = 50000
  frontend_port_end              = 50119
  backend_port                   = 3306
  frontend_ip_configuration_name = "DbPublicIPAddress"
}

resource "azurerm_lb_probe" "db" {
  resource_group_name = azurerm_resource_group.generic.name
  name                = "db-probe"
  loadbalancer_id     = azurerm_lb.db.id
  protocol            = "Tcp"
  port                = 3306
}
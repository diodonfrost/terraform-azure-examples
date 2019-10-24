resource "azurerm_public_ip" "http" {
  name                = "http-ip"
  location            = azurerm_resource_group.generic.location
  resource_group_name = azurerm_resource_group.generic.name
  allocation_method   = "Static"
}

resource "azurerm_lb" "http" {
  name                = "http-lb"
  location            = azurerm_resource_group.generic.location
  resource_group_name = azurerm_resource_group.generic.name

  frontend_ip_configuration {
    name                 = "HttpPublicIPAddress"
    public_ip_address_id = azurerm_public_ip.http.id
  }
}

resource "azurerm_lb_backend_address_pool" "http" {
  resource_group_name = azurerm_resource_group.generic.name
  name                = "HttpBackEndAddressPool"
  loadbalancer_id     = azurerm_lb.http.id
}

resource "azurerm_lb_nat_pool" "http" {
  resource_group_name            = azurerm_resource_group.generic.name
  name                           = "http-nat-pool"
  loadbalancer_id                = azurerm_lb.http.id
  protocol                       = "Tcp"
  frontend_port_start            = 50000
  frontend_port_end              = 50119
  backend_port                   = 80
  frontend_ip_configuration_name = "HttpPublicIPAddress"
}

resource "azurerm_lb_probe" "http" {
  resource_group_name = azurerm_resource_group.generic.name
  name                = "http-probe"
  loadbalancer_id     = azurerm_lb.http.id
  protocol            = "Tcp"
  port                = 80
}
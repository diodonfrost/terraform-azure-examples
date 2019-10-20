resource "azurerm_public_ip" "db" {
  name                = "db-pip"
  location            = azurerm_resource_group.generic.location
  resource_group_name = azurerm_resource_group.generic.name
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "db" {
  name                = "db-nic"
  location            = azurerm_resource_group.generic.location
  resource_group_name = azurerm_resource_group.generic.name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.http.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.db.id
  }
}

resource "azurerm_virtual_machine" "db" {
  name                  = var.db_vm_name
  location              = azurerm_resource_group.generic.location
  resource_group_name   = azurerm_resource_group.generic.name
  network_interface_ids = [azurerm_network_interface.db.id]
  vm_size               = "Standard_DS1_v2"

  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "db-osdisk1"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
    custom_data    = file("scripts/first-boot.sh")
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}

resource "azurerm_managed_disk" "db" {
  name                 = "db-volume"
  location             = azurerm_resource_group.generic.location
  resource_group_name  = azurerm_resource_group.generic.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 15
}

resource "azurerm_virtual_machine_data_disk_attachment" "db" {
  managed_disk_id    = azurerm_managed_disk.db.id
  virtual_machine_id = azurerm_virtual_machine.db.id
  lun                = "10"
  caching            = "ReadWrite"
}

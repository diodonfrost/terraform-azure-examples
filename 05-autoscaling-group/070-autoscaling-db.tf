resource "azurerm_virtual_machine_scale_set" "db" {
  name                = "db-scale-set"
  location            = azurerm_resource_group.generic.location
  resource_group_name = azurerm_resource_group.generic.name

  upgrade_policy_mode = "Manual"

  sku {
    name     = "Standard_F2"
    tier     = "Standard"
    capacity = 2
  }

  storage_profile_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  storage_profile_os_disk {
    name              = ""
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name_prefix = "db-vm"
    admin_username       = "testadmin"
    admin_password       = "Password1234!"
    custom_data          = file("scripts/first-boot-db.sh")
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  network_profile {
    name    = "internal"
    primary = true

    ip_configuration {
      name                                   = "internal"
      subnet_id                              = azurerm_subnet.db.id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.db.id]
      primary                                = true
    }
  }
}

resource "azurerm_monitor_autoscale_setting" "db" {
  name                = "dbAutoscaleSetting"
  resource_group_name = azurerm_resource_group.generic.name
  location            = azurerm_resource_group.generic.location
  target_resource_id  = azurerm_virtual_machine_scale_set.db.id

  profile {
    name = "defaultProfile"

    capacity {
      default = var.autoscaling_db.desired_capacity
      minimum = var.autoscaling_db.min_size
      maximum = var.autoscaling_db.max_size
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_virtual_machine_scale_set.db.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = 75
      }

      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_virtual_machine_scale_set.db.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = 25
      }

      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }
  }
}
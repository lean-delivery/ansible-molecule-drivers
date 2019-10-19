#############################################################
# Azurerm Backend
#############################################################
terraform {
  backend "azurerm" {}
}

#############################################################
# Azure Provider
#############################################################
provider "azurerm" {
  version = "=1.34.0"
}
#############################################################
# Data section
#############################################################
data "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  virtual_network_name = var.virtual_network_name
  resource_group_name  = var.resource_group_name
}

data "azurerm_network_security_group" "nsg" {
  name                = var.network_security_group
  resource_group_name = var.resource_group_name
}

#############################################################
# Resource section
#############################################################
resource "azurerm_public_ip" "vmss-ip" {
  name                = "${var.vmss_name}-ip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Dynamic"
  domain_name_label   = var.vmss_name

  tags = local.tags
}

resource "azurerm_lb" "vmss-lb" {
  name                = "${var.vmss_name}-lb"
  location            = var.location
  resource_group_name = var.resource_group_name

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.vmss-ip.id
  }

  tags = local.tags
}

resource "azurerm_lb_backend_address_pool" "vmss-lb-bap" {
  name                = "BackEndAddressPool"
  resource_group_name = var.resource_group_name
  loadbalancer_id     = azurerm_lb.vmss-lb.id
}

resource "azurerm_lb_probe" "vmss-lb-probe" {
  name                = var.ssh_port != null ? "ssh-running-probe" : "winrm-running-probe"
  resource_group_name = var.resource_group_name
  loadbalancer_id     = azurerm_lb.vmss-lb.id
  protocol            = "Tcp"
  port                = var.ssh_port != null ? 22 : 5986
}

resource "azurerm_lb_rule" "vmss-lb-rule" {
  name                           = var.ssh_port != null ? "ssh" : "winrm"
  resource_group_name            = var.resource_group_name
  loadbalancer_id                = azurerm_lb.vmss-lb.id
  frontend_ip_configuration_name = "PublicIPAddress"
  protocol                       = "Tcp"
  # Conditional for Linux/Windows images
  frontend_port           = var.ssh_port != null ? var.ssh_port : var.winrm_port
  backend_port            = var.ssh_port != null ? 22 : 5986
  backend_address_pool_id = azurerm_lb_backend_address_pool.vmss-lb-bap.id
  probe_id                = azurerm_lb_probe.vmss-lb-probe.id
}

resource "azurerm_virtual_machine_scale_set" "vmss" {
  name                = "${var.vmss_name}-ss"
  location            = var.location
  resource_group_name = var.resource_group_name

  upgrade_policy_mode = "Manual"

  overprovision   = false
  priority        = "low"
  eviction_policy = "Delete"

  sku {
    name     = var.vm_size
    tier     = "Standard"
    capacity = 1
  }

  identity {
    type = "SystemAssigned"
  }

  storage_profile_image_reference {
    publisher = var.img_publisher
    offer     = var.img_offer
    sku       = var.img_sku
    version   = var.img_version
  }

  storage_profile_os_disk {
    name              = ""
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = var.disk_type
  }

  os_profile {
    # remove "tst-" prefix, name prefixes must be 1 to 9 characters long for Windows
    computer_name_prefix = substr(var.vmss_name, 4, 8)
    admin_username       = var.admin_username
    admin_password       = var.admin_password
  }

  # Terraform v0.12 new feature - Dynamic Nested Blocks
  # https://www.hashicorp.com/blog/hashicorp-terraform-0-12-preview-for-and-for-each

  # Dynamic argument block only for Linux nodes
  # Will be omited if Windows node requested
  dynamic "os_profile_linux_config" {
    for_each = var.ssh_public_key != null ? local.ssh_keys : []

    content {
      disable_password_authentication = true
      ssh_keys {
        path     = os_profile_linux_config.value.path
        key_data = os_profile_linux_config.value.key_data
      }
    }
  }

  # Dynamic argument block only for Windows nodes
  # Will be omited if Linux node requested
  dynamic "os_profile_windows_config" {
    for_each = var.ssh_public_key != null ? [] : local.windows_config

    content {
      provision_vm_agent        = os_profile_windows_config.value.provision_vm_agent
      enable_automatic_upgrades = os_profile_windows_config.value.enable_automatic_upgrades
    }
  }

  # Dynamic argument block only for Windows nodes
  # Will be omited if Linux node requested
  dynamic "extension" {
    for_each = var.ssh_public_key != null ? [] : local.windows_extension

    content {
      name                       = extension.value.name
      publisher                  = extension.value.publisher
      type                       = extension.value.type
      type_handler_version       = extension.value.type_handler_version
      auto_upgrade_minor_version = extension.value.auto_upgrade_minor_version
      settings                   = extension.value.settings
    }
  }

  network_profile {
    name                      = var.virtual_network_name
    primary                   = true
    network_security_group_id = data.azurerm_network_security_group.nsg.id

    ip_configuration {
      name                                   = "ipconfig1"
      primary                                = true
      subnet_id                              = data.azurerm_subnet.subnet.id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.vmss-lb-bap.id]
    }
  }

  tags = local.tags
}

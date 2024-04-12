provider "azurerm" {
  version = "<=2.0.0"

  subscription_id=var.subscriptionID
  client_id = var.clientID
  client_secret = var.clientSecret
  tenant_id = var.tenantID
  features {}
}

resource "azurerm_resource_group" "terraform" {
  name = var.RGName
  location = var.location

}

resource "azurerm_virtual_network" "app_network" {
  name                = var.VirtualNetwork
  location            = var.location
  resource_group_name = azurerm_resource_group.terraform
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "SubnetA" {
  name                 = var.subnet
  resource_group_name  = azurerm_resource_group.terraform.name
  virtual_network_name = azurerm_virtual_network.app_network.name
  address_prefix     = ["10.0.2.0/24"]
  depends_on           = [azurerm_virtual_network.app_network ]
}

resource "azurerm_network_interface" "VM_interface" {
  name                = var.VM_interface
  location            = var.location
  resource_group_name = azurerm_resource_group.terraform

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.SubnetA.id
    private_ip_address_allocation = "Dynamic"
  }

  depends_on = [
    azurerm_virtual_network.app_network
  ]
}

resource "azurerm_linux_virtual_machine" "linux_vm" {
  name                = var.vmname
  resource_group_name = azurerm_resource_group.terraform
  location            = var.location
  size                = "Standard_D2s_v3"
  admin_username      = "linuxusr"
  admin_password      = "Azure@123"
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.app_interface.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  depends_on = [
    azurerm_network_interface.VM_interface
  ]
}


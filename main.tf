provider "azurerm" {
  version = "1.8.0"

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
  resource_group_name = azurerm_resource_group.terraform.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "SubnetA" {
  name                 = var.subnet
  resource_group_name  = azurerm_resource_group.terraform.name
  virtual_network_name = azurerm_virtual_network.app_network.name
  address_prefix     = var.VMSubnet
  depends_on           = [azurerm_virtual_network.app_network ]
}

resource "azurerm_network_interface" "VM_interface" {
  name                = var.VM_interface
  location            = var.location
  resource_group_name = azurerm_resource_group.terraform.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.SubnetA.id
    private_ip_address_allocation = "Dynamic"
  }

  depends_on = [
    azurerm_virtual_network.app_network,azurerm_public_ip.publicIP
  ]
}

resource "azurerm_linux_virtual_machine" "linuxvm" {
  name                = var.vmname
  resource_group_name = azurerm_resource_group.terraform.name
  location            = var.location
  size                = "Standard_D2s_v3"
  admin_username      = "linuxusr"
  admin_password      = "Azure@123"
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.VM_interface.id,
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

###public_IP
resource "azurerm_public_ip" "publicIP" {
  name                = var.publicIP
  resource_group_name = azurerm_resource_group.terraform.name
  location            = var.location
  allocation_method   = "Static"
  depends_on = [
    azurerm_resource_group.terraform
  ]
}

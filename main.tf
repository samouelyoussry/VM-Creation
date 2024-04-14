provider "azurerm" {
  version = "<=2.0.0"

  subscription_id=var.subscriptionID
  client_id = var.clientID
  client_secret = var.clientSecret
  tenant_id = var.tenantID
  features {}
}
resource "azurerm_resource_group" "test1_rg" {
  name     = var.test1_resource_group_name
  location = var.location
}

resource "azurerm_resource_group" "test2_rg" {
  name     = var.test2_resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.virtual_network_name
  address_space       = [var.vnet_address_space]
  location            = azurerm_resource_group.test1_rg.location
  resource_group_name = azurerm_resource_group.test1_rg.name
}

resource "azurerm_subnet" "subnet_a" {
  name                 = var.subnet_a_name
  resource_group_name  = azurerm_resource_group.test1_rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.subnet_a_address_prefix
  depends_on           = [azurerm_virtual_network.vnet]
}

resource "azurerm_subnet" "subnet_b" {
  name                 = var.subnet_b_name
  resource_group_name  = azurerm_resource_group.test1_rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.subnet_b_address_prefix
  depends_on           = [azurerm_virtual_network.vnet]
}

resource "azurerm_network_interface" "app_nic" {
  count               = 2
  name                = "${var.app_vm_name[count.index]}-nic"
  location            = azurerm_resource_group.test1_rg.location
  resource_group_name = azurerm_resource_group.test1_rg.name

  ip_configuration {
    name                          = "${var.app_vm_name[count.index]}-nic-config"
    subnet_id                     = count.index == 0 ? azurerm_subnet.subnet_a.id : azurerm_subnet.subnet_b.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_public_ip" "app_public_ip" {
  name                = var.app_public_ip_name
  location            = azurerm_resource_group.test1_rg.location
  resource_group_name = azurerm_resource_group.test1_rg.name
  allocation_method   = "Dynamic"
}

resource "azurerm_network_security_group" "nsg_subnet_a" {
  name                = var.nsg_subnet_a_name
  location            = azurerm_resource_group.test1_rg.location
  resource_group_name = azurerm_resource_group.test1_rg.name

  security_rule {
    name                       = "allow_rdp"
    description                = "Allow RDP"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_security_group" "nsg_subnet_b" {
  name                = var.nsg_subnet_b_name
  location            = azurerm_resource_group.test1_rg.location
  resource_group_name = azurerm_resource_group.test1_rg.name

  security_rule {
    name                       = "allow_rdp"
    description                = "Allow RDP"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_virtual_machine" "app_vm" {
  count                = 2
  name                 = var.app_vm_name[count.index]
  location             = azurerm_resource_group.test1_rg.location
  resource_group_name  = azurerm_resource_group.test1_rg.name
  network_interface_ids = [azurerm_network_interface.app_nic[count.index].id]

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "${var.app_vm_name[count.index]}-os-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = var.app_vm_name[count.index]
    admin_username = var.admin_username
    admin_password = var.admin_password
  }

  os_profile_linux_config {

    disable_password_authentication = false
  }

  tags = {
    environment = "test"
  }
}

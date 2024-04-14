variable "subscriptionID" {
  type = string
}
variable "clientID" {
  type = string  
}
variable "clientSecret" {
  type = string  
}
variable "tenantID" {
  type = string
}
variable "location" {
  description = "The location/region where the resources will be created."
  type        = string
  default     = "eastus"
}

variable "test1_resource_group_name" {
  description = "Name of the test1 resource group."
  type        = string
  default     = "test1"
}

variable "test2_resource_group_name" {
  description = "Name of the test2 resource group."
  type        = string
  default     = "test2"
}

variable "virtual_network_name" {
  description = "Name of the virtual network."
  type        = string
  default     = "test-vnet"
}

variable "vnet_address_space" {
  description = "Address space of the virtual network."
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_a_name" {
  description = "Name of subnet A."
  type        = string
  default     = "subnet-a"
}

variable "subnet_b_name" {
  description = "Name of subnet B."
  type        = string
  default     = "subnet-b"
}

variable "subnet_a_address_prefix" {
  description = "Address prefix of subnet A."
  type        = string
}

variable "subnet_b_address_prefix" {
  description = "Address prefix of subnet B."
  type        = string
}

variable "app_vm_name" {
  description = "Names of the application virtual machines."
  type        = list(string)
  default     = ["app-vm-1", "app-vm-2"]
}
variable "VMSize" {
  description = "VMSize"
  type        = string
  default     = "Standard_D2s_v3"
}

variable "app_public_ip_name" {
  description = "Name of the public IP attached to the app VM."
  type        = string
  default     = "app-public-IP"
}

variable "nsg_subnet_a_name" {
  description = "Name of the NSG attached to subnet A."
  type        = string
  default     = "nsg-subnet-a"
}

variable "nsg_subnet_b_name" {
  description = "Name of the NSG attached to subnet B."
  type        = string
  default     = "nsg-subnet-b"
}

variable "admin_username" {
  description = "Admin username for the virtual machines."
  type        = string
  default     = "adminuser"
}

variable "admin_password" {
  description = "Admin password for the virtual machines."
  type        = string
  default     = "AdminPa$$w0rd"
}

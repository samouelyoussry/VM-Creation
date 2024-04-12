
variable "RGName" {
  type = string
}

variable "VirtualNetwork" {
  type = string
}

variable "subnet" {
  type = string
}

variable "VnetAddress" {
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "VMsubnet" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
}
variable "VM_interface" {
  type = string
}

variable "vmname" {
  type = string
}
variable "location" {
  type = string 
}
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

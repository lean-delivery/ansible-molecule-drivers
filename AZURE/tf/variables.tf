#############################################################
# Description of resources
#############################################################
variable "resource_group_name" {
  type    = string
  default = "epm-ldi"
}
variable "location" {
  type    = string
  default = "northeurope"
}
variable "virtual_network_name" {
  type    = string
  default = "epm-ldi-northeurope-vnet"
}
variable "subnet_name" {
  type    = string
  default = "epm-ldi-northeurope-subnet"
}
variable "network_security_group" {
  type    = string
  default = "epm-ldi-northeurope-sg"
}
variable "vmss_name" {
  type    = string
  default = ""
}
variable "vm_size" {
  type    = string
  default = "Standard_DS1_v2"
}
variable "disk_type" {
  default = "Standard_LRS"
}
variable "admin_username" {
  default = "vm-admin"
}
# Terraform v0.12 new feature - Conditionally Omitted Arguments
# https://www.hashicorp.com/blog/terraform-0-12-conditional-operator-improvements
variable "admin_password" {
  type    = string
  default = null
}
variable "ssh_public_key" {
  type    = string
  default = null
}
variable "ssh_port" {
  type    = number
  default = null
}
variable "winrm_port" {
  type    = number
  default = null
}

#############################################################
# Description of image
#############################################################
variable "img_publisher" {
  type    = string
  default = "Canonical"
}
variable "img_offer" {
  type    = string
  default = "UbuntuServer"
}
variable "img_sku" {
  type    = string
  default = "18.04-LTS"
}
variable "img_version" {
  type    = string
  default = "latest"
}

#############################################################
# Description of resource tags
#############################################################
variable "tag_instance" {
  type    = string
  default = ""
}
variable "tag_name" {
  type    = string
  default = ""
}
variable "tag_os" {
  type    = string
  default = "Linux"
}

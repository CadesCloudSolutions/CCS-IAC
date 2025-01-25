variable "host_os" {
  type = string
}

variable "prefix" {
  default = "ctx-prod"
}

variable "cidr_block" {
  default = ["10.0.1.0/24"]
  type    = list(string)
}

variable "address_space" {
  default = ["10.0.0.0/16"]
  type    = list(string)
}

variable "environment" {
  default = "prod"
}

variable "location" {
  default = "north europe"
  type    = string
}

variable "username" {
  default = "adminuser"
  type    = string
}

variable "vm_name" {
  default = "prod-linux-vm"
}

variable "vm_sku" {
  default = "Standard_B2ms"
  type    = string
}

variable "disk_size_gb" {
    default = 60
    type = number
}
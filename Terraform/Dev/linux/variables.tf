variable "host_os" {
  type = string
}

variable "prefix" {
  default = "ctx-dev"
}

variable "suffix" {
  default = "ctx-dev"
}

variable "storage" {
  default = "01"
}

variable "cidr_block" {
  default = ["10.0.1.0/24"]
  type    = list(string)
}

variable "address_space" {
  default = ["10.0.0.0/16"]
  type    = list(string)
}


variable "environment_dev" {
  default = "dev"
}

variable "location" {
  default = "uksouth"
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
    default = 30
    type = number
}
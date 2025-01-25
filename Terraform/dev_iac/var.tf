variable "service_name" {
  type    = string
  default = ""
}

variable "storage_account_name" {
    type = string 
    default = "cadestfstate"
}

variable "resource_group_name" {
    type = string 
    default = "cadesdefault"
}

variable "account_replication_type" {
    type = string
    default = "LRS"
}

variable "account_tier" {
    type = string 
    default = "Standard"
}

variable "location" {
    type = string
    default = "uksouth"
}
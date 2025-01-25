variable "service_name" {
  type    = string
  default = ""
}

variable "storage_account_name" {
    type = string 
    default = "cadestfstate20"
}

variable "resource_group_name" {
    type = string 
    default = "cadesdefault20"
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
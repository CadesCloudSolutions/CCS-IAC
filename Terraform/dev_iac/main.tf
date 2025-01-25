terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.91.0"
    }

    backed
  }
}

provider "azurerm" {
  features {}
}
 

resource "azurerm_storage_account" "storage_account" { 
    name = var.storage_account_name 
    resource_group_name = var.resource_group_name
    account_replication_type = var.account_replication_type
    account_tier = var.account_tier 
    location = var.location

}

resource "azurerm_resource_group" "rg" {
    name = var.resource_group_name
    location = var.location
}
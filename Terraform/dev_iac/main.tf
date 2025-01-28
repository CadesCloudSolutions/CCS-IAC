terraform {

        backend "azurerm" {
        resource_group_name = "azurerm_resouce_group.rg.name" 
        storage_account_name = "azurerm_storage_account.storage_acc.name"
        container_name = "azurerm_storage_container.storage_container.name"
        key = "terraform.tfstate"
       }
        //backend "local" {
        //    path = "CCS-IAC/Terraform/dev_iac/terraform.tfstate"
        //}
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.91.0"
    }
  }
}

provider "azurerm" {
  features {}
}


 

resource "azurerm_storage_container" "storage_container" {
    name = "terraform-storage-container20"
    storage_account_name = azurerm_storage_account.storage_acc.name 
    //container_access_type = "public"
}

resource "azurerm_storage_account" "storage_acc" { 
    name = "${var.storage_account_name}" 
    resource_group_name = "${var.resource_group_name}"
    account_replication_type = "${var.account_replication_type}"
    account_tier = "${var.account_tier}"
    location = "${var.location}"

}

resource "azurerm_resource_group" "rg" {
    name = "${var.resource_group_name}"
    location = "${var.location}"
}
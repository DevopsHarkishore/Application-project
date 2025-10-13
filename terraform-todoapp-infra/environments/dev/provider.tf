terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.41.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "harkishore"
    storage_account_name = "infrastorage121"
    container_name       = "infracontainer"
    key                  = "dev.tfstate"
  }
}

provider "azurerm" {
  features {}
  subscription_id = "d73ab938-2a60-42e2-87cd-9362d4e73029"
}

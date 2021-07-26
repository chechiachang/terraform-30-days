terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.65.0"
    }
  }

  required_version = ">= 1.0.1"

  # remote Backend
  backend "azurerm" {
    resource_group_name  = "terraform-30-days"
    storage_account_name = "tfstatee903f2ef317fb0b4"
    container_name       = "tfstate"
    key                  = "container_registry.tfstate"
  }
}

provider "azurerm" {
  features {}
}

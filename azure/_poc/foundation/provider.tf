terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.65.0"
    }
  }

  required_version = ">= 1.0.1"
}

provider "azurerm" {
  features {}
}

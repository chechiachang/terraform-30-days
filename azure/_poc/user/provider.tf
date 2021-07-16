terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azuread"
      version = "~> 0.7.0"
    }
  }

  required_version = ">= 1.0.1"
}

provider "azuread" {
  features {}
}

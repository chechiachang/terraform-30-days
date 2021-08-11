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
    resource_group_name  = "terraform-30-days-poc"
    storage_account_name = "tfstate8b8bff248c5c60c0"
    container_name       = "tfstate"
    key                  = "_poc/compute/terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

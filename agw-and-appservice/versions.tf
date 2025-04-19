terraform {
  required_version = "~> 1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }

  # Important! Define this block in order to save your state.
  # backend "azurerm" {
  #   container_name       = "your_container_name"
  #   resource_group_name  = "your_resource_group_name"
  #   snapshot             = true
  #   storage_account_name = "your_storage_account_name"
  #   subscription_id      = "your_subscription_id"
  # }
}

terraform {
  backend "azurerm" {
    resource_group_name  = "tf-state-rg"
    storage_account_name = "tfstate87654"
    container_name       = "tfstate"
    key                  = "dev.terraform.tfstate"
  }
}
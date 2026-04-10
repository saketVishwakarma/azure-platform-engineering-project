provider "azurerm" {
    features{}
  
}


resource "azurerm_resource_group" "rg" {
  name     = "dev-rg"
  location = "Central India"
}
module "vnet" {
  source = "../../modules/vnet"

  vnet_name = "dev-vnet"
  location  = "Central India"
  rg_name   = azurerm_resource_group.rg.name

  subnets = {
    aks_subnet = "10.0.1.0/24"
    app_subnet = "10.0.2.0/24"
  }
}
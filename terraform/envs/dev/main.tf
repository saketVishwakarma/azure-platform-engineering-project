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
resource "random_string" "suffix" {
  length  = 5
  special = false
  upper   = false
}

resource "azurerm_container_registry" "acr" {
  name                = "devacr${random_string.suffix.result}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"
  admin_enabled       = true
}


resource "azurerm_kubernetes_cluster" "aks" {
  name                = "dev-aks"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "devaks"

  default_node_pool {
    name       = "nodepool"
    node_count = 2
    vm_size    = "Standard_B2s"
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "azure"
  }
}

resource "azurerm_role_assignment" "acr_pull" {
  principal_id                     = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.acr.id
}
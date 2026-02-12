resource "azurerm_container_registry" "acr" {
  name                = "${var.acr_name}${random_id.acr_suffix.hex}" # Must be globally unique
  resource_group_name = azurerm_resource_group.aks_rg.name
  location            = azurerm_resource_group.aks_rg.location
  sku                 = "Basic"
  admin_enabled       = false # Secure: Use Identity, not Admin passwords
}

# 3. Azure Kubernetes Service (AKS)
resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_cluster_name
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
  dns_prefix          = "volvogroup"

  default_node_pool {
    name       = "defaultnp"
    node_count = 1
    vm_size    = "Standard_B2s" # Cost-effective for development
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "kubenet"
    load_balancer_sku = "standard"
  }
}
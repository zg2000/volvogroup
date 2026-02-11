# terraform/main.tf
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "prd-sea-ci-kubernetes-rg"
    storage_account_name = "sealokiprod" # global unique
    container_name       = "loki-container-test"
    key                  = "prod.terraform.tfstate" # remote state

    # OIDC authentication
    use_oidc = true
  }
}
provider "azurerm" {
  features {}
  # OIDC authentication
  use_oidc = true
}

resource "random_id" "acr_suffix" {
  byte_length = 4
}

resource "azurerm_resource_group" "aks_rg" {
  name     = var.resource_group_name
  location = var.location # Volvo context: closer to Gothenburg
}

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
    name       = "default"
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

resource "azurerm_role_assignment" "aks_to_acr" {
  principal_id                     = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.acr.id
  skip_service_principal_aad_check = true
}

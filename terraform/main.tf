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

module "acr" {
 source             = "./modules/acr"
 tags               = local.tags
}

module "aks" {
 source             = "./modules/aks"
 tags               = local.tags
}

resource "azurerm_role_assignment" "aks_to_acr" {
  principal_id                     = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.acr.id
  skip_service_principal_aad_check = true
}

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
 resource_group_name = azurerm_resource_group.aks_rg.name
 location            = azurerm_resource_group.aks_rg.location
 acr_name = var.acr_name
}

module "aks" {
 source  = "./modules/aks"
 resource_group_name = azurerm_resource_group.aks_rg.name
 location            = azurerm_resource_group.aks_rg.location
 acr_id  =  module.acr.acr_id
}



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

resource "random_id" "server" {
  byte_length = 4
}

resource "azurerm_resource_group" "testrg" {
  name     = "rg-nodejs-app"
  location = "East US"
}

resource "azurerm_service_plan" "testsp" {
  name                = "plan-nodejs"
  resource_group_name = azurerm_resource_group.testrg.name
  location            = azurerm_resource_group.testrg.location
  os_type             = "Linux"
  sku_name            = "B1" # save cost
}

resource "azurerm_linux_web_app" "testwa" {
  name                = "webapp-nodejs-${random_id.server.hex}" # global unique
  resource_group_name = azurerm_resource_group.testrg.name
  location            = azurerm_service_plan.testsp.location
  service_plan_id     = azurerm_service_plan.testsp.id

  site_config {
    application_stack {
      node_version = "20-lts"
    }
  }
}

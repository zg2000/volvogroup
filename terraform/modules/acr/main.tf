resource "random_id" "acr_suffix" {
  byte_length = 4
}


resource "azurerm_container_registry" "acr" {
  name                = "${var.acr_name}${random_id.acr_suffix.hex}" # Must be globally unique
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Basic"
  admin_enabled       = false # Secure: Use Identity, not Admin passwords
}


resource "azurerm_resource_group" "rg-dev-env" {
  name     = var.rg-name
  location = var.location
}

resource "azurerm_container_registry" "as-acr" {
  name                = var.container_registry_name
  resource_group_name = azurerm_resource_group.rg-dev-env.name
  location            = azurerm_resource_group.rg-dev-env.location
  sku                 = "Basic"
}
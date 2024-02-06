# Import the Container Registry created in the acr file

data "azurerm_container_registry" "as-cr" {
  name                = var.container_registry_name
  resource_group_name = var.rg-name
}


resource "azurerm_resource_group" "rg-dev-env" {
  name     = var.rg-name-k8s
  location = var.location
}

resource "azurerm_role_assignment" "acr-attach" {
  principal_id                     = azurerm_kubernetes_cluster.aks_devops_cluster.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = data.azurerm_container_registry.as-cr.id
  skip_service_principal_aad_check = true
}

resource "azurerm_kubernetes_cluster" "aks_devops_cluster" {
  name                = var.cluster-name
  location            = azurerm_resource_group.rg-dev-env.location
  resource_group_name = azurerm_resource_group.rg-dev-env.name
  dns_prefix          = "devops-aks1"
  sku_tier            = "Free"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_B2pls_v2" #ARM64 ARCH # 2CPU 4RAM # Option2 X86: "Standard_B2s"
    os_disk_size_gb = 30
  }

  # Login via az cli tool, no service principal needed.
  identity {
    type = "SystemAssigned"
  }

}

# To save costs, you can only deploy the default node pool (limited testing)

#resource "azurerm_kubernetes_cluster_node_pool" "devops_node_pool" {
#  name                  = "internal"
#  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks_devops_cluster.id
#  vm_size               = var.vm_size
#  node_count            = 1
#
#  tags = {
#    Environment = "test"
#  }
#}

output "client_certificate" {
  value     = azurerm_kubernetes_cluster.aks_devops_cluster.kube_config.0.client_certificate
  sensitive = true
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.aks_devops_cluster.kube_config_raw

  sensitive = true
}

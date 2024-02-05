resource "azurerm_resource_group" "rg-dev-env" {
  name     = var.rg-name-k8s
  location = var.location
}

resource "azurerm_kubernetes_cluster" "aks_devops_cluster" {
  name                = var.cluster-name
  location            = azurerm_resource_group.rg-dev-env.location
  resource_group_name = azurerm_resource_group.rg-dev-env.name
  dns_prefix          = "devops-aks1"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_B2s"
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

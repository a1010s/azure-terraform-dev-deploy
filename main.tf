module "vm" {
  source         = "./modules/vm"
  vm-name        = var.vm-name
  admin_username = var.admin_username
  rg-name        = var.rg-name
  location       = var.location
  vm_size        = var.vm_size
}

module "acr" {
  source = "./modules/acr"

  rg-name               = var.rg-name
  location              = var.location
  container_registry_name = var.container_registry_name
}

module "aks_cluster" {
  source                  = "./modules/kubernetes"
  container_registry_name = var.container_registry_name
  rg-name                 = var.rg-name
  location                = "West US" #  West US 3 -> cheapest | For Basic Azure Subscription need a different location
  cluster-name            = var.cluster-name
  vm_size                 = "Standard_B2s" # B2ats_v2 is too small
  depends_on              = [module.acr]   # Explicit dependency on ACR module (for attachment)
}

# string interpolation within the output block
output "public_ip_address" {
  value = "ssh ${var.admin_username}@${module.vm.public_ip_address}"
}

output "client_certificate" {
  value     = module.aks_cluster.client_certificate
  sensitive = true
}

output "kube_config" {
  value = module.aks_cluster.kube_config

  sensitive = true
}

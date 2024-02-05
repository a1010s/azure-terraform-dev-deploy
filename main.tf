module "vm" {
  source           = "./modules/vm"
  vm-name          = var.vm-name
  admin_username   = var.admin_username
  rg-name          = var.rg-name
  location         = var.location
  vm_size          = var.vm_size
}

module "aks_cluster" {
  source = "./modules/kubernetes"

  rg-name        = var.rg-name
  location       = "West US"  # For Basic Azure Subscription need a different location
  cluster-name   = var.cluster-name
  vm_size        = "Standard_B2s" # B2ats_v2 is too small
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

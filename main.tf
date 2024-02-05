module "vm" {
  source           = "./modules/vm"
  vm-name          = var.vm-name
  admin_username   = var.admin_username
  rg-name          = var.rg-name
  location         = var.location
  vm_size          = var.vm_size
}

# string interpolation within the output block
output "public_ip_address" {
  value = "ssh ${var.admin_username}@${module.vm.public_ip_address}"
}

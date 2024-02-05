variable "rg-name" {
  default = "RG_VM-DEV-ENV"
}

variable "location" {
  default = "East US"
}

variable "vm_size" {
  default = "Standard_B2ats_v2"
}
variable "admin_username" {

}

variable "vm-name" {
  default = "dev-test-B2ats-v2"
}

variable "network-name" {
  default = "VNET-DEV"
}

variable "vnet-address-space" {
  default = ["172.16.0.0/16"]

}

variable "snet-address-space" {
  default = ["172.16.1.0/24"]
}

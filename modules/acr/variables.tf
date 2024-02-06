variable "rg-name" {
  default = "RG_VM-DEV-ENV"
}

variable "rg-name-k8s" {
  default = "RG_Kubernetes"
}

variable "location" {
  default = "East US"
}

variable "vm_size" {
  default = "Standard_B2ats_v2"
}

variable "cluster-name" {
  default = "aks_devops_cluster"
}

variable "container_registry_name" {
  
}
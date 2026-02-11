variable "resource_group_name" {
  type        = string
  description = "The name of the Resource Group"
  default     = "rg-volvo-nodeapp"
}

variable "location" {
  type        = string
  description = "Azure region to deploy resources"
  default     = "Sweden Central"
}

variable "acr_name" {
  type        = string
  description = "Unique name for the Azure Container Registry"
}

variable "aks_cluster_name" {
  type        = string
  description = "Name of the AKS cluster"
  default     = "aks-volvo-cluster"
}

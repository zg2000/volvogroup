variable "acr_name" {
  type        = string
  description = "Unique name for the Azure Container Registry"
}

variable "aks_cluster_name" {
  type        = string
  description = "Name of the AKS cluster"
  default     = "aks-volvo-cluster"
}
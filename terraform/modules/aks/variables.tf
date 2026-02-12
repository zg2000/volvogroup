variable "aks_cluster_name" {
  type        = string
  description = "Name of the AKS cluster"
  default     = "aks-volvo-cluster"
}

variable "acr_id" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}
variable "acr_name" {
  type        = string
  description = "Unique name for the Azure Container Registry"
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}
variable "location" {
  type = string
  description = "AzureRegions for all resources"
}

variable "env" {
    type = string 
    description = "eg: dev, prod"
}

variable "vnet_ad" {
    type = list(string)
}

variable "snet_p" {
  type = string
}

variable "vm_size" {
    type = string
}

variable "vm_username" {
    type = string
}

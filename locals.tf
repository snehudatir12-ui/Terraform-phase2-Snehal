locals {
prefix = "ntms-$(var.env)"

#resources_names
rg_name = "rg-$(local.prefix)"
vnet_name = "vnet-$(local.prefix)"
nsg_name = "nsg-$(local.prefix)"
pip_name = "pip-$(local.prefix)"
vm_name = "vm-$(local.prefix)"

common_tags = {
env = var.env
project = "ntms-workshop"
owner = "ntms-ayushi"
}
}
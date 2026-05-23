output "pip_o" {
    value = azurerm_public_ip.pip.ip_address
}

output "rdp_command" {
  value = "mstsc /v:${azurerm_public_ip.pip.ip_address}"
}

output "rg_nameo" {
  value = azurerm_resource_group.RG.name
}
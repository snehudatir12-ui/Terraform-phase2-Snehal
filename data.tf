data "azurerm_key_vault" "kv" {
    name = "kv-ntms-workshop"
    resource_group_name = "kv-ntms-workshop"
  }

  data "azurerm_key_vault_secret" "vm_password" {
    name = "vm-admin-password"
    key_vault_id = data.azurerm_key_vault.kv.id
    
  }
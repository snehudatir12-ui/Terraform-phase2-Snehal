
resource "azurerm_resource_group" "RG" {
 name = local.rg_name   
  location = var.location
  tags = local.common_tags
}
resource "azurerm_virtual_network" "VNET" {
 name = local.vnet_name
 location = azurerm_resource_group.RG.location
 resource_group_name = azurerm_resource_group.RG.name
 address_space = var.vnet_ad
 tags = local.common_tags
 }
 resource "azurerm_subnet" "snet" {
   name = "subnet"
   virtual_network_name = azurerm_virtual_network.VNET.name
   resource_group_name = azurerm_resource_group.RG.name
   address_prefixes = [var.snet_p]
 }
 resource "azurerm_network_security_group" "NSG" {
    name = local.nsg_name
    location = azurerm_resource_group.RG.location
    resource_group_name = azurerm_resource_group.RG.name
    tags = local.common_tags
  }

resource "azurerm_network_security_rule" "rule" {
name = "test123"
priority = 300
direction = "Inbound"
access = "Allow"
protocol = "Tcp"
source_port_range = "*"
destination_port_range = "3389"
source_address_prefix = "*"
destination_address_prefix = "*"
resource_group_name = azurerm_resource_group.RG.name
network_security_group_name = azurerm_network_security_group.NSG.name
}


resource "azurerm_subnet_network_security_group_association" "nsg-ass" {
  subnet_id = azurerm_subnet.snet.id
  network_security_group_id = azurerm_network_security_group.NSG.id

  depends_on = [ 
    azurerm_subnet.snet,
    azurerm_network_security_group.NSG
   ]
}

resource "azurerm_public_ip" "pip" {
 name = local.pip_name
  location = azurerm_resource_group.RG.location
  resource_group_name = azurerm_resource_group.RG.name
  allocation_method = "Static"
  sku = "StandardV2"
  tags = local.common_tags
}

resource "azurerm_network_interface" "nic" {
  name = "nic1"
  location = azurerm_resource_group.RG.location
  resource_group_name = azurerm_resource_group.RG.name
  ip_configuration {
    name = "internal"
    subnet_id = azurerm_subnet.snet.id
     private_ip_address_allocation = "Dynamic"
     public_ip_address_id = azurerm_public_ip.pip.id
  }
}
resource "azurerm_windows_virtual_machine" "VM" {
  name                = local.vm_name
  resource_group_name = azurerm_resource_group.RG.name
  location            = azurerm_resource_group.RG.location
  size                = var.vm_size
  admin_username      = var.vm_username
  admin_password      = data.azurerm_key_vault_secret.vm_password.value
  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
  tags = local.common_tags
}

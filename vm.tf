resource "azurerm_linux_virtual_machine" "devops20180076" {
  name                = "devops20180076"
  resource_group_name = data.azurerm_resource_group.tp4.name
  location            = var.region
  size                = "Standard_D2s_v3"
  admin_username      = "devops"
  network_interface_ids = [
    azurerm_network_interface.mynetinterface.id
  ]

  admin_ssh_key {
    username   = "devops"
    public_key = tls_private_key.ssh.public_key_openssh
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}

resource "azurerm_network_interface" "mynetinterface" {
  name                = "nic20180076"
  location            = var.region
  resource_group_name = data.azurerm_resource_group.tp4.name

  ip_configuration {
    name                          = data.azurerm_subnet.tp4.name
    subnet_id                     = data.azurerm_subnet.tp4.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.myvm1publicip20180076.id
  }
}

resource   "azurerm_public_ip"   "myvm1publicip20180076"   { 
   name                 =   "pip20180076" 
   location             =   var.region 
   resource_group_name  =   data.azurerm_resource_group.tp4.name
   allocation_method    =   "Dynamic" 
   sku                  =   "Basic" 
 } 


resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}


output "private_key" {
  value     = tls_private_key.ssh.private_key_pem
  sensitive = true
}
# Resource Group created with tag association
resource "azurerm_resource_group" "stw-rg" {
  name     = "ccs-${var.prefix}-rg"
  location = var.location

  tags = {
    environment = var.environment
  }
}

#Virtual Network with tag association
resource "azurerm_virtual_network" "stw-vnet" {
  name                = "ccs-vnet-${var.prefix}"
  resource_group_name = azurerm_resource_group.stw-rg.name
  location            = azurerm_resource_group.stw-rg.location
  address_space       = var.address_space

  tags = {
    environment = var.environment
  }
}

#Subnet
resource "azurerm_subnet" "stw-subnet" {
  name                 = "ccs-subnet-${var.prefix}"
  resource_group_name  = azurerm_resource_group.stw-rg.name
  virtual_network_name = azurerm_virtual_network.stw-vnet.name
  address_prefixes     = var.cidr_block
}

#Network Security Group with tags
resource "azurerm_network_security_group" "stw-nsg" {
  name                = "ccs-${var.prefix}-nsg"
  location            = azurerm_resource_group.stw-rg.location
  resource_group_name = azurerm_resource_group.stw-rg.name

  tags = {
    environment = var.environment
  }
}
#NSG Security inbound (ingress) allow rule
resource "azurerm_network_security_rule" "stw-prod-rule" {
  name                        = "ccs-${var.prefix}-rule"
  priority                    = 350
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "81.97.169.163/32"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.stw-rg.name
  network_security_group_name = azurerm_network_security_group.stw-nsg.name
}


#NSG Security outbound (egress) allow rule
resource "azurerm_network_security_rule" "ccs-prod-rule" {
  name                        = "ccs-${var.prefix}-rule01"
  priority                    = 1000
  direction                   = "outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "81.97.169.164/32"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.stw-rg.name
  network_security_group_name = azurerm_network_security_group.stw-nsg.name
}
resource "azurerm_subnet_network_security_group_association" "stw-nsg-association" {
  subnet_id                 = azurerm_subnet.stw-subnet.id
  network_security_group_id = azurerm_network_security_group.stw-nsg.id
}


resource "azurerm_public_ip" "stw-ip-prod" {
  name                = "ccs-ip-${var.prefix}"
  resource_group_name = azurerm_resource_group.stw-rg.name
  location            = azurerm_resource_group.stw-rg.location
  allocation_method   = "Dynamic"

  tags = {
    environment = var.environment
  }
}

#NIC
resource "azurerm_network_interface" "stw-nic-prod" {
  name                = "ccs-nic-${var.prefix}"
  location            = azurerm_resource_group.stw-rg.location
  resource_group_name = azurerm_resource_group.stw-rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.stw-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.stw-ip-prod.id

  }

  tags = {
    environment = var.environment
  }
}

#LINUX VM
resource "azurerm_linux_virtual_machine" "stw-prod-linux-vm" {
  name                  = "ccs-${var.vm_name}"
  resource_group_name   = azurerm_resource_group.stw-rg.name
  location              = azurerm_resource_group.stw-rg.location
  size                  = var.vm_sku
  admin_username        = var.username
  network_interface_ids = [azurerm_network_interface.stw-nic-prod.id]

  custom_data = filebase64("customdata.tpl")

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/stwazurekey.pub")
  }


  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = var.disk_size_gb
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }


  provisioner "local-exec" {
    command = templatefile("${var.host_os}-ssh-script.tpl", {
      hostname     = self.public_ip_address,
      user         = "adminuser",
      identityfile = "~/.ssh/stwazurekey"
    })
    interpreter = var.host_os == "windows" ? ["Powershell", "-Command"] : ["bash", "-c"]
  }

  tags = {
    environment = var.environment
  }

}

#Data source public IP 
data "azurerm_public_ip" "stw-ip-data" {
  name                = azurerm_public_ip.stw-ip-prod.name
  resource_group_name = azurerm_resource_group.stw-rg.name
}

#outputs 
output "public_ip_address" {
  value = "${azurerm_linux_virtual_machine.stw-prod-linux-vm.name}: ${data.azurerm_public_ip.stw-ip-data.ip_address}"
}
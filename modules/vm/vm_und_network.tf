resource "azurerm_resource_group" "rg-dev-env" {
  name     = var.rg-name
  location = var.location
}

resource "azurerm_virtual_network" "vnet-dev" {
  name                = var.network-name
  address_space       = var.vnet-address-space
  location            = azurerm_resource_group.rg-dev-env.location
  resource_group_name = azurerm_resource_group.rg-dev-env.name
}

resource "azurerm_subnet" "snet-dev" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.rg-dev-env.name
  virtual_network_name = azurerm_virtual_network.vnet-dev.name
  address_prefixes     = var.snet-address-space
}

resource "azurerm_public_ip" "pub-ip" {
  name                    = "${var.vm-name}-public-ip"
  location                = azurerm_resource_group.rg-dev-env.location
  resource_group_name     = azurerm_resource_group.rg-dev-env.name
  allocation_method       = "Dynamic"
  idle_timeout_in_minutes = 30

  tags = {
    environment = "test"
  }
}

resource "azurerm_network_interface" "vm-nic" {
  name                = "${var.vm-name}-nic"
  location            = azurerm_resource_group.rg-dev-env.location
  resource_group_name = azurerm_resource_group.rg-dev-env.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.snet-dev.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pub-ip.id
  }
}

resource "azurerm_linux_virtual_machine" "vm-resource" {
  name                = var.vm-name
  resource_group_name = azurerm_resource_group.rg-dev-env.name
  location            = azurerm_resource_group.rg-dev-env.location
  size                = var.vm_size
  admin_username      = var.admin_username
  network_interface_ids = [
    azurerm_network_interface.vm-nic.id,
  ]

  admin_ssh_key {
    username   = var.admin_username
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}


data "azurerm_public_ip" "pub-ip" {
  name                = azurerm_public_ip.pub-ip.name
  resource_group_name = azurerm_linux_virtual_machine.vm-resource.resource_group_name
}

# string interpolation within the output block
output "public_ip_address" {
  value = data.azurerm_public_ip.pub-ip.ip_address
  depends_on = [azurerm_linux_virtual_machine.vm-resource]
}
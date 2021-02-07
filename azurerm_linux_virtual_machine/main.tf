# Create a resource group
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group#example-usage
resource "azurerm_resource_group" "tf-rg-miguel" {
  name     = "tf-rg-miguel"
  location = "West Europe"

  tags = {
    Description = "RG created with Terraform"
    Environment = "Test"
  }
}

resource "azurerm_virtual_network" "tf-virtual-network-miguel" {
  name                = "tf-virtual-network-miguel"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.tf-rg-miguel.location
  resource_group_name = azurerm_resource_group.tf-rg-miguel.name
}

resource "azurerm_subnet" "tf-subnet-miguel" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.tf-rg-miguel.name
  virtual_network_name = azurerm_virtual_network.tf-virtual-network-miguel.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "tf-network-interface-miguel" {
  name                = "tf-network-interface-miguel"
  location            = azurerm_resource_group.tf-rg-miguel.location
  resource_group_name = azurerm_resource_group.tf-rg-miguel.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.tf-subnet-miguel.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "tf-linux-vm-miguel" {
  name                = "tf-linux-vm-miguel"
  resource_group_name = azurerm_resource_group.tf-rg-miguel.name
  location            = azurerm_resource_group.tf-rg-miguel.location
  size                = "Standard_B1ls"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.tf-network-interface-miguel.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
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

  tags = {
    Description = "VM created with Terraform"
    Environment = "Test"
  }
}

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

# Create a Network Security Group
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group#example-usage
resource "azurerm_network_security_group" "tf-nsg-miguel" {
  name                = "tf-nsg-miguel"
  location            = azurerm_resource_group.tf-rg-miguel.location
  resource_group_name = azurerm_resource_group.tf-rg-miguel.name

  security_rule {
    name                       = "allow-all-ssh-inbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow-all-http-https-inbound"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["80","443"]
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    Description = "Azure NSG created with Terraform"
    Environment = "Test"
  }
}

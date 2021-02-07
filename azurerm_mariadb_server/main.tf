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

# Create Azure MariaDB Server
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mariadb_server#example-usage
resource "azurerm_mariadb_server" "tf-mariadbserver-miguel" {
  name                = "tf-mariadbserver-miguel"
  location            = azurerm_resource_group.tf-rg-miguel.location
  resource_group_name = azurerm_resource_group.tf-rg-miguel.name

  administrator_login          = "miguel"
  administrator_login_password = "Passw0rd!"

  sku_name   = "B_Gen5_1"
  storage_mb = 5120
  version    = "10.2"

  auto_grow_enabled             = true
  backup_retention_days         = 7
  geo_redundant_backup_enabled  = false
  ssl_enforcement_enabled       = true

  tags = {
    Description = "MariaDB server created with Terraform"
    Environment = "Test"
  }
}

# Allow access to Azure services
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mariadb_firewall_rule
resource "azurerm_mariadb_firewall_rule" "tf-mariadb-fw-rule-miguel" {
  name                = "tf-mariadb-fw-rule-miguel"
  resource_group_name = azurerm_resource_group.tf-rg-miguel.name
  server_name         = azurerm_mariadb_server.tf-mariadbserver-miguel.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}

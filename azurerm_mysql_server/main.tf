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

# Create Azure MySQL Server
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mysql_server#example-usage
resource "azurerm_mysql_server" "tf-mysqlserver-miguel" {
  name                = "tf-mysqlserver-miguel"
  location            = azurerm_resource_group.tf-rg-miguel.location
  resource_group_name = azurerm_resource_group.tf-rg-miguel.name

  administrator_login          = "miguel"
  administrator_login_password = "Passw0rd!"

  sku_name   = "B_Gen5_1"
  storage_mb = 5120
  version    = "5.7"

  auto_grow_enabled                 = true
  backup_retention_days             = 7
  geo_redundant_backup_enabled      = false
  infrastructure_encryption_enabled = false
  public_network_access_enabled     = true
  ssl_enforcement_enabled           = true
  ssl_minimal_tls_version_enforced  = "TLS1_2"

  tags = {
    Description = "MySQL server created with Terraform"
    Environment = "Test"
  }
}

# Allow access to Azure services
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mysql_firewall_rule#example-usage-allow-access-to-azure-services
resource "azurerm_mysql_firewall_rule" "tf-mysql-fw-rule-miguel" {
  name                = "tf-mysql-fw-rule-miguel"
  resource_group_name = azurerm_resource_group.tf-rg-miguel.name
  server_name         = azurerm_mysql_server.tf-mysqlserver-miguel.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}

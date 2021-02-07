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

# Create Azure PostgreSQL Server
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_server#example-usage
resource "azurerm_postgresql_server" "tf-postgresqlserver-miguel" {
  name                = "tf-postgresqlserver-miguel"
  location            = azurerm_resource_group.tf-rg-miguel.location
  resource_group_name = azurerm_resource_group.tf-rg-miguel.name

  administrator_login          = "miguel"
  administrator_login_password = "Passw0rd!"

  sku_name   = "B_Gen5_1"
  version    = "9.6"
  storage_mb = 640000

  backup_retention_days        = 7
  #geo_redundant_backup_enabled = true
  auto_grow_enabled            = true

  public_network_access_enabled    = true
  ssl_enforcement_enabled          = true
  ssl_minimal_tls_version_enforced = "TLS1_2"

  tags = {
    Description = "PostgreSQL server created with Terraform"
    Environment = "Test"
  }
}

# Allow access to Azure services
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_firewall_rule
resource "azurerm_postgresql_firewall_rule" "tf-postgresql-fw-rule-miguel" {
  name                = "tf-mysql-fw-rule-miguel"
  resource_group_name = azurerm_resource_group.tf-rg-miguel.name
  server_name         = azurerm_postgresql_server.tf-postgresqlserver-miguel.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}

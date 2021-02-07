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

# Create storage account
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account
resource "azurerm_storage_account" "tf-storage-account-miguel" {
  name                     = "tfstorageaccountmiguel"
  resource_group_name      = azurerm_resource_group.tf-rg-miguel.name
  location                 = azurerm_resource_group.tf-rg-miguel.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    Description = "Storage Account created with Terraform"
    Environment = "Test"
  }
}

# Create storage file share
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container#example-usage
resource "azurerm_storage_container" "tf-storage-container" {
  name                  = "tf-storage-container"
  storage_account_name  = azurerm_storage_account.tf-storage-account-miguel.name
  container_access_type = "private"
}

# Upload main.tf file to storage file share
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_blob#example-usage
resource "azurerm_storage_blob" "tf-storage-blob-1" {
  name                   = "main.tf"
  storage_account_name   = azurerm_storage_account.tf-storage-account-miguel.name
  storage_container_name = azurerm_storage_container.tf-storage-container.name
  type                   = "Block"
  source                 = "./main.tf"
}

# Upload provider.tf file to storage file share
resource "azurerm_storage_blob" "tf-storage-blob-2" {
  name                   = "provider.tf"
  storage_account_name   = azurerm_storage_account.tf-storage-account-miguel.name
  storage_container_name = azurerm_storage_container.tf-storage-container.name
  type                   = "Block"
  source                 = "./provider.tf"
}
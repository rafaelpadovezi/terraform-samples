resource "azurerm_resource_group" "rg" {
  name     = "poc-db-rg"
  location = var.resource_group_location
}

resource "random_password" "admin_password" {
  length      = 20
  min_lower   = 1
  min_special = 1
  special     = true
  min_numeric = 1
  min_upper   = 1
}

resource "azurerm_mssql_server" "sqlserver" {
  version                      = "12.0"
  resource_group_name          = azurerm_resource_group.rg.name
  name                         = "poc-db-sqlserver"
  location                     = azurerm_resource_group.rg.location
  administrator_login_password = local.admin_password
  administrator_login          = var.admin_username
}

resource "azurerm_mssql_database" "db" {
  server_id = azurerm_mssql_server.sqlserver.id
  name      = var.sql_db_name
}

resource "azurerm_management_lock" "can_not_delete" {
  scope      = azurerm_resource_group.rg.id
  name       = "poc-db-lock"
  lock_level = "CanNotDelete"
}


terraform {
  required_providers {
    azurerm = {
      version = "= 3.73.0"
    }
  }
}
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  location = var.resource_group_location
  name     = "poc-db-rg"
}

resource "random_password" "admin_password" {
  length      = 20
  special     = true
  min_numeric = 1
  min_upper   = 1
  min_lower   = 1
  min_special = 1
}

locals {
  admin_password = random_password.admin_password.result
}

resource "azurerm_mssql_server" "sqlserver" {
  name                         = "poc-db-sqlserver"
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = azurerm_resource_group.rg.location
  version                      = "12.0"
  administrator_login          = var.admin_username
  administrator_login_password = local.admin_password
}

resource "azurerm_mssql_database" "db" {
  name      = var.sql_db_name
  server_id = azurerm_mssql_server.sqlserver.id
}

output "admin_password" {
  sensitive = true
  value     = local.admin_password
}
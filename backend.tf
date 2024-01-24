terraform {
  backend "azurerm" {
    storage_account_name = "brainboardpoc0001"
    container_name       = "terraform-state"
    key                  = "terraform.tfstate"
  }
}
  
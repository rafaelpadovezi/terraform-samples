terraform {
  backend "azurerm" {
    storage_account_name = "brainboardpoc0001"
    container_name       = "terraform-state"
    key                  = "84d71b78-139f-4a65-8ccf-42f156e8f32d"
  }
}
  
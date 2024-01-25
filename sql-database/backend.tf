backend "azurerm" {
  resource_group_name  = "rg-terraform-state"
  storage_account_name = "brainboardpoc0001"
  container_name       = "terraform-state"
  key                  = "ea53ca6c-44e7-412d-9ecb-20aa47b5aaa0.tfstate"
}
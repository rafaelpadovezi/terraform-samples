terraform {
  required_providers {
    azurerm = {
      version = "= 3.73.0"
    }

    kubernetes = {
      version = "= 2.25.2"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "brainboardpoc0001"
    container_name       = "terraform-state"
    key                  = "terraform.tfstate"
  }
}
provider "azurerm" {
  features {}
}

provider "kubernetes" {
  host = azurerm_kubernetes_cluster.test.kube_config.0.host

  client_certificate     = base64decode(azurerm_kubernetes_cluster.test.kube_config.0.client_certificate)
  client_key             = base64decode(azurerm_kubernetes_cluster.test.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.test.kube_config.0.cluster_ca_certificate)
}
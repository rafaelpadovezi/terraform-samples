terraform {
  required_providers {
    azurerm = {
      version = "= 3.73.0"
    }

    kubernetes = {
      version = "= 2.25.2"
    }
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

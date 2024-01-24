output "client_certificate" {
  sensitive = true
  value     = azurerm_kubernetes_cluster.test.kube_config.0.client_certificate
}

output "kube_config" {
  sensitive = true
  value     = azurerm_kubernetes_cluster.test.kube_config_raw
}

output "kubernetes_cluster_name" {
  value = azurerm_kubernetes_cluster.test.name
}

output "resource_group_name" {
  value = azurerm_resource_group.apim-aks.name
}


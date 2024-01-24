output "client_certificate" {
  value     = azurerm_kubernetes_cluster.test.kube_config.0.client_certificate
  sensitive = true
}

output "kube_config" {
  value     = azurerm_kubernetes_cluster.test.kube_config_raw
  sensitive = true
}

output "resource_group_name" {
  value = azurerm_resource_group.apim-aks.name
}

output "kubernetes_cluster_name" {
  value = azurerm_kubernetes_cluster.test.name
}

#output "load_balancer_hostname" {
#  value = kubernetes_service.example.status.0.load_balancer.0.ingress.0.hostname
#}
#
#output "load_balancer_ip" {
#  value = kubernetes_service.example.status.0.load_balancer.0.ingress.0.ip
#}

#output "apim_url" {
#  value = azurerm_api_management.apim.management_api_url
#}

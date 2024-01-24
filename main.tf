resource "azurerm_resource_group" "apim-aks" {
  name     = "blog-apim-and-aks"
  location = "WestUS2"
}

resource "azurerm_virtual_network" "apim-aks" {
  name                = "apim-aks-vnet"
  address_space       = ["10.10.0.0/16"]
  location            = azurerm_resource_group.apim-aks.location
  resource_group_name = azurerm_resource_group.apim-aks.name
}

resource "azurerm_subnet" "aks" {
  name                 = "aks-subnet"
  resource_group_name  = azurerm_resource_group.apim-aks.name
  virtual_network_name = azurerm_virtual_network.apim-aks.name
  address_prefixes     = ["10.10.1.0/24"]
}

resource "azurerm_subnet" "apim" {
  name                 = "apim-subnet"
  resource_group_name  = azurerm_resource_group.apim-aks.name
  virtual_network_name = azurerm_virtual_network.apim-aks.name
  address_prefixes     = ["10.10.2.0/24"]
}

resource "azurerm_kubernetes_cluster" "test" {
  name                = "aks-for-apim"
  location            = azurerm_resource_group.apim-aks.location
  resource_group_name = azurerm_resource_group.apim-aks.name
  dns_prefix          = "nfaksapim"

  default_node_pool {
    name            = "default"
    node_count      = 1
    vm_size         = "Standard_D2_v2"
    os_disk_size_gb = 30
    vnet_subnet_id  = azurerm_subnet.aks.id
  }

  identity {
    type = "SystemAssigned"
  }
}
locals {

}

resource "azurerm_role_assignment" "role_assignment_cluster_subnet" {
  principal_id         = azurerm_kubernetes_cluster.test.identity.0.principal_id
  role_definition_name = "Contributor"
  scope                = azurerm_virtual_network.apim-aks.id
}

resource "azurerm_api_management" "apim" {
  name                 = "blog-apim-003"
  location             = azurerm_resource_group.apim-aks.location
  resource_group_name  = azurerm_resource_group.apim-aks.name
  publisher_name       = "Rafael"
  publisher_email      = "rafaelpadovezi@gmail.com"
  sku_name             = "Developer_1"
  virtual_network_type = "External"
  virtual_network_configuration {
    subnet_id = azurerm_subnet.apim.id
  }
}

resource "azurerm_api_management_api" "back-end-api2" {
  name                = "example-api2"
  resource_group_name = azurerm_resource_group.apim-aks.name
  api_management_name = azurerm_api_management.apim.name
  revision            = "1"
  display_name        = "Example API"
  path                = "nginx"
  service_url         = "http://${kubernetes_service.example.status.0.load_balancer.0.ingress.0.ip}"
  protocols           = ["http"]

  depends_on = [kubernetes_service.example]
}

resource "azurerm_api_management_api_operation" "get" {
  operation_id        = "get"
  api_name            = azurerm_api_management_api.back-end-api2.name
  api_management_name = azurerm_api_management.apim.name
  resource_group_name = azurerm_resource_group.apim-aks.name
  display_name        = "get"
  method              = "GET"
  url_template        = "/"

  response {
    status_code = 200
  }
}
resource "azurerm_resource_group" "apim-aks" {
  name     = "blog-apim-and-aks"
  location = local.location
}

resource "azurerm_virtual_network" "apim-aks" {
  resource_group_name = azurerm_resource_group.apim-aks.name
  name                = "apim-aks-vnet"
  location            = local.location

  address_space = [
    "10.10.0.0/16",
  ]
}

resource "azurerm_subnet" "aks" {
  virtual_network_name = azurerm_virtual_network.apim-aks.name
  resource_group_name  = azurerm_resource_group.apim-aks.name
  name                 = "aks-subnet"

  address_prefixes = [
    "10.10.1.0/24",
  ]
}

resource "azurerm_subnet" "apim" {
  virtual_network_name = azurerm_virtual_network.apim-aks.name
  resource_group_name  = azurerm_resource_group.apim-aks.name
  name                 = "apim-subnet"

  address_prefixes = [
    "10.10.2.0/24",
  ]
}

resource "azurerm_kubernetes_cluster" "test" {
  resource_group_name = azurerm_resource_group.apim-aks.name
  name                = "aks-for-apim"
  location            = local.location
  dns_prefix          = "nfaksapim"

  default_node_pool {
    vnet_subnet_id  = azurerm_subnet.aks.id
    vm_size         = "Standard_D2_v2"
    os_disk_size_gb = 30
    node_count      = 1
    name            = "default"
  }

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_role_assignment" "role_assignment_cluster_subnet" {
  scope                = azurerm_virtual_network.apim-aks.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_kubernetes_cluster.test.identity.0.principal_id
}

resource "azurerm_api_management" "apim" {
  virtual_network_type = "External"
  sku_name             = "Developer_1"
  resource_group_name  = azurerm_resource_group.apim-aks.name
  publisher_name       = "Rafael"
  publisher_email      = "rafaelpadovezi@gmail.com"
  name                 = "blog-apim-003"
  location             = local.location

  virtual_network_configuration {
    subnet_id = azurerm_subnet.apim.id
  }
}

resource "azurerm_api_management_api" "back-end-api2" {
  service_url         = "http://${kubernetes_service.example.status.0.load_balancer.0.ingress.0.ip}"
  revision            = "1"
  resource_group_name = azurerm_resource_group.apim-aks.name
  path                = "nginx"
  name                = "example-api2"
  display_name        = "Example API"
  api_management_name = azurerm_api_management.apim.name

  depends_on = [
    "kubernetes_service.example",
  ]

  protocols = [
    "http",
  ]
}

resource "azurerm_api_management_api_operation" "get" {
  url_template        = "/"
  resource_group_name = azurerm_resource_group.apim-aks.name
  operation_id        = "get"
  method              = "GET"
  display_name        = "get"
  api_name            = azurerm_api_management_api.back-end-api2.name
  api_management_name = azurerm_api_management.apim.name

  response {
    status_code = 200
  }
}

resource "azurerm_api_management_api_operation" "api_mgt_api_operation" {
  url_template        = "/test"
  resource_group_name = azurerm_resource_group.apim-aks.name
  operation_id        = "get-test"
  method              = "GET"
  display_name        = "get-test"
  api_name            = azurerm_api_management_api.back-end-api2.id
  api_management_name = azurerm_api_management.apim.name

  response {
    status_code = 200
  }
  response {
    status_code = 400
  }
}


resource "azurerm_resource_group" "main" {
  name     = "qr-code-rg"
  location = "East US"
}

// Virtual Network
resource "azurerm_virtual_network" "main" {
  name                = "my-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

// Subnets
resource "azurerm_subnet" "subnet_1" {
  name                 = "subnet1"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.0.0/20"]
}

resource "azurerm_subnet" "subnet_2" {
  name                 = "subnet2"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.16.0/20"]
}

resource "azurerm_subnet" "subnet_3" {
  name                 = "subnet3"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.32.0/20"]
}

// Route Table
resource "azurerm_route_table" "main" {
  name                = "rt-main"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  route {
    name           = "internet"
    address_prefix = "0.0.0.0/0"
    next_hop_type  = "Internet"
  }
}

// Associate Subnets with Route Table
resource "azurerm_subnet_route_table_association" "subnet_1" {
  subnet_id      = azurerm_subnet.subnet_1.id
  route_table_id = azurerm_route_table.main.id
}

resource "azurerm_subnet_route_table_association" "subnet_2" {
  subnet_id      = azurerm_subnet.subnet_2.id
  route_table_id = azurerm_route_table.main.id
}

resource "azurerm_subnet_route_table_association" "subnet_3" {
  subnet_id      = azurerm_subnet.subnet_3.id
  route_table_id = azurerm_route_table.main.id
}

// Azure Kubernetes Service (AKS)
resource "azurerm_kubernetes_cluster" "main" {
  name                = "my-aks-cluster"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  dns_prefix          = "myakscluster"

  default_node_pool {
    name           = "default"
    node_count     = 1
    vm_size        = "Standard_DS2_v2"
    vnet_subnet_id = azurerm_subnet.subnet_1.id
    zones          = ["2"]
  }

  network_profile {
    network_plugin    = "azure"
    service_cidr      = "10.1.0.0/16"
    dns_service_ip    = "10.1.0.10"
    load_balancer_sku = "standard"
  }

  identity {
    type = "SystemAssigned"
  }
}

// Azure Storage Account
resource "azurerm_storage_account" "storage" {
  name                     = "qrcodesa123"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "development"
  }
}
// Azure Storage Container
resource "azurerm_storage_container" "container" {
  name                  = "qr-codes"
  storage_account_id    = azurerm_storage_account.storage.id
  container_access_type = "blob"
}


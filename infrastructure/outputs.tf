output "resource_group_name" {
  description = "The name of the resource group"
  value       = azurerm_resource_group.main.name

}

output "aks_cluster_name" {
  description = "The name of the AKS cluster"
  value       = azurerm_kubernetes_cluster.main.name
}

output "storage_account_name" {
  description = "The name of the storage account"
  value       = azurerm_storage_account.storage.name
}

output "container_name" {
  description = "The name of the container"
  value       = azurerm_storage_container.container.name
}

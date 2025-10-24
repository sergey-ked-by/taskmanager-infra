
# main.tf for azure-aks module

resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix

  default_node_pool {
    name       = "default"
    node_count = var.node_count
    vm_size    = "Standard_B2s" # A good, cost-effective size for testing
    vnet_subnet_id = var.vnet_subnet_id
  }

  # Use a system-assigned managed identity for simplicity
  identity {
    type = "SystemAssigned"
  }

  # Attach the Azure Container Registry to the AKS cluster.
  # This automatically handles the required 'AcrPull' role assignment.


  # Network settings
  network_profile {
    network_plugin = "azure"
    service_cidr   = "10.0.3.0/24"
    dns_service_ip = "10.0.3.10"
  }
}

# Grant the AKS Kubelet Identity the AcrPull role on the Azure Container Registry.
resource "azurerm_role_assignment" "acr_pull_role_assignment" {
  scope                = var.acr_id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.aks.identity[0].principal_id
}


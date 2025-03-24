# Terraform Infrastructure Module

This Terraform module provisions the necessary Azure resources required for the QR Code Generator application. The resources include:

- **Resource Group:** for organizing resources.
- **Virtual Network and Subnets:** A virtual network (`my-vnet`) with three subnets and route table associations for networking.
- **Route Table:** A default route table with an Internet route to allow outbound connectivity.
- **Azure Kubernetes Service (AKS):** A managed Kubernetes cluster with a default node pool for deploying the application.
- **Azure Storage Account and Container:** for storing QR code images.

---

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) (v1.0.0 or newer recommended)
- [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli) (optional, but recommended for authentication and debugging)
- An active Azure subscription ([Azure Account](https://azure.microsoft.com/free/))

---

## Files Overview

- **main.tf:** Contains all the resource definitions, including the resource group, virtual network, subnets, route tables and associations, AKS cluster, Azure Storage Account, and Storage Container.
- **providers.tf:** Configures Terraform providers with Azure Resource Manager provider `azurerm`
- **(Optional Files):** You may create additional files (e.g., `variables.tf` and `outputs.tf`) to manage variables and outputs if your module grows in complexity.


## Authentication with Azure CLI

Before running Terraform commands, authenticate with Azure and set the required environment variables:

1. **Log in to Azure:**
   ```bash
   az login
   ```

2. **Set the Azure Subscription ID:** 

   For PowerShell:
   ```powershell
   $env:ARM_SUBSCRIPTION_ID = (az account show --query id -o tsv)
   ```
   For Bash:
   ```bash
   export ARM_SUBSCRIPTION_ID=$(az account show --query id -o tsv)
   ```
---

## Resources Created

### Networking

- **Resource Group:**  
  - Name: Defined in `azurerm_resource_group.main`
  - Location: (e.g., `East US`)
  
- **Virtual Network (`my-vnet`)**
  - Address Space: `10.0.0.0/16`
  - Subnets:
    - `subnet1`: with address prefix `10.0.0.0/20`
    - `subnet2`: with address prefix `10.0.16.0/20`
    - `subnet3`: with address prefix `10.0.32.0/20`
  - Each subnet is associated with a route table that routes all traffic to the Internet.
  
- **Route Table (`rt-main`)**
  - Default route to the Internet
  - Associated with all subnets

### Kubernetes
- **Azure Kubernetes Service (AKS)**
  - Name: `my-aks-cluster`
  - DNS Prefix: `myakscluster`
  - Default Node Pool: Uses subnet1, spans one availability zone (`zone 2`), and uses `Standard_DS2_v2` VM size.
  - Networking: Azure CNI configured with `10.1.0.0/16` service CIDR, DNS service IP (`10.1.0.10`)
  - Load Balancer: Standard SKU
  - Managed Identity: SystemAssigned for Kubernetes cluster operations.

### Storage
- **Azure Storage Account (`qrcodesa123`)**
  - Tier: Standard
  - Replication: LRS
- **Azure Storage Container (`qr-codes`)**
  - Access Type: Blob (public read access)

---

## Usage

1. **Clone the Repository:**
   ```bash
   git clone <repository_url>
   cd <repository_directory>/infrastructure
   ```

2. **Initialize Terraform:**
   ```bash
   terraform init
   ```

3. **Review the Plan:**
   
      Generate and review an execution plan to verify what resources will be created:
   ```bash
   terraform plan
   ```

4. **Apply the Configuration:**

    Apply the Terraform configuration to create the resources in your Azure subscription:
   ```bash
   terraform apply -auto-approve
   ```
     This will provision the resource group, virtual network, AKS cluster, storage account, and storage container.

1. **Connect to the AKS Cluster:**
   After the AKS cluster is created, configure `kubectl` to connect to it:
   ```bash
   az aks get-credentials --resource-group qr-code-rg --name my-aks-cluster
   ```

---

## Cleanup

To destroy all resources created by this module, run:
```bash
terraform destroy -auto-approve
```

---

## Troubleshooting

### Authentication Issues
- Ensure you are logged in to Azure:
  ```bash
  az login
  ```
- Verify the correct subscription is set:
  ```bash
  az account show
  ```
- For further documentation on the Azure provider, check [Terraform Azure Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs).
- For any questions or issues, please refer to the [Terraform Documentation](https://developer.hashicorp.com/terraform/docs).

### AKS Connection Issues
- If you cannot connect to the AKS cluster, try overwriting the existing kubeconfig:
  ```bash
  az aks get-credentials --resource-group qr-code-rg --name my-aks-cluster --overwrite-existing
  ```

### Storage Access Issues
- Verify the storage account exists:
  ```bash
  az storage account show --name qrcodesa123 --resource-group qr-code-rg
  ```
- Check the container's access level:
  ```bash
  az storage container show --name qr-codes --account-name qrcodesa123
  ```

---

## Notes

- **Configuration:**  
  Be sure to adjust any hard-coded values (e.g., resource names, location, subnet prefixes) to match your environment or follow your naming standards.
  
- **Authentication:**  
  Terraform will use your current Azure CLI logged-in session or Environment variables (`ARM_CLIENT_ID`, `ARM_CLIENT_SECRET`, `ARM_TENANT_ID`, and `ARM_SUBSCRIPTION_ID`) for authentication.

- **Further Customization:**  
  Consider splitting the Terraform code into separate modules (e.g., networking, AKS, storage) for easier management as the project grows.

  ## Troubleshooting

- **Terraform Errors:**  
  Check the error messages output from `terraform plan` or `terraform apply` for guidance.
  
- **Azure Resource Issues:**  
  Use the [Azure Portal](https://portal.azure.com) or Azure CLI to verify resource creation and configuration.
  
- **Debugging:**  
  Increase logging levels by setting the environment variable `TF_LOG=DEBUG` before running Terraform commands.


## Notes

- The storage container is configured with public blob access for QR code retrieval.
- The AKS cluster uses Azure CNI networking for better integration with Azure resources.
- The virtual network is segmented into three subnets for flexibility in workload separation.
- Environment: This configuration is set up for a development environment (environment = "development" tag). Adjust tags or variable values as needed for your production setup.
- Access: Make sure the networking and access rules in your Azure subscription allow the required services to communicate.
- Further Customization: You might want to split the configuration into separate modules (e.g., networking, storage) for larger projects.

---

## Security Considerations

- The AKS cluster uses a system-assigned managed identity for secure operations.
- The storage account is configured with standard security features.
- Public blob access is enabled for the storage container to allow QR code retrieval via URLs.

---

This `README.md` provides a comprehensive guide to deploying and managing the infrastructure resources for the QR Code Generator application using Terraform.
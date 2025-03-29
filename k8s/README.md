# Kubernetes Manifests

This directory contains Kubernetes manifests for deploying the QR Code Generator application.

## Contents
- **backend-deployment.yaml**  
  - Contains the Deployment and Service definitions for the backend API (FastAPI).
- **frontend-deployment.yaml**  
  - Contains the Deployment and Service definitions for the frontend application (Next.js).
- **backend-ingress.yaml** (optional)  
  - Defines an Ingress resource to expose the backend API externally if needed.

## Prerequisites

- A Kubernetes cluster (e.g., AKS).
- `kubectl` installed and configured to connect to your cluster.
- An Azure Storage Account with a container for QR codes created using the configuration below.

## Azure Storage Setup

In your Azure Storage Account:
- The **Storage Account** name should be set as per your configuration.
- A container named **qr-codes** should exist.
- Your QR code images will be stored under a folder (for example, `qr_codes`) inside that container.
  
## Kubernetes Deployment

This project uses a declarative approach with YAML manifests to deploy resources on your Kubernetes cluster (e.g., AKS). Follow these steps to deploy the manifests:

1. **Set the Default Resource Group**

   Configure the Azure CLI to use your resource group by default:
   ```bash
   az configure --defaults group=<resource-group-name>
   ```
   This command sets the default resource group for subsequent `az` CLI operations.

2. **Retrieve AKS Credentials**

   Download your AKS cluster credentials and merge them into your kubeconfig:
   ```bash
   az aks get-credentials --resource-group <your-resource-group> --name <your-aks-cluster>
   ```
   This allows you to interact with your AKS cluster using `kubectl`.

3. **Verify the Current Kubernetes Context**

   Confirm that your kubeconfig is pointing to the correct cluster:
   ```bash
   kubectl config current-context
   ```
   This should display the context associated with your AKS cluster.

4. **Deploy the Kubernetes Manifests**

   Apply your YAML manifests (e.g., Deployments, Services, Ingress, and Secrets) using:
   ```bash
   kubectl apply -f <manifest-file.yaml>
   ```

    This declarative approach ensures that your Kubernetes resources are version-controlled and easily reproducible.
## Secret Configuration

Before deploying the application, create an Azure Storage Secret for the storage account connection string.
- Get connection string using storage account name.

```bash
# bash
CONNECTION_STRING=$(az storage account show-connection-string \
--name <STORAGE_ACCOUNT_NAME> \
--resource-group <RESOURCE_GROUP_NAME> \
--query connectionString \
--output tsv)
```
```powershell
# powershell
$connectionString = az storage account show-connection-string `
    --name "<STORAGE_ACCOUNT_NAME>" `
    --resource-group "<RESOURCE_GROUP_NAME>" `
    --query connectionString `
    --output tsv
```
- Create secret with only the connection string
```bash
# bash
kubectl create secret generic azure-storage-secret \
--from-literal=AZURE_STORAGE_CONNECTION_STRING="$CONNECTION_STRING" \
--dry-run=client -o yaml | kubectl apply -f -
```
```powershell
# powershell
kubectl create secret generic azure-storage-secret `
    --from-literal=AZURE_STORAGE_CONNECTION_STRING="$connectionString" `
    --dry-run=client -o yaml | kubectl apply -f -
```   
- Verify secret creation
```bash
kubectl get secret azure-storage-secret
```
## Update backend-deployment.yaml for local testing
````yaml
# filepath: \k8s\backend-deployment.yaml
env:
  - name: AZURE_STORAGE_CONNECTION_STRING
    valueFrom:
      secretKeyRef:
        name: azure-storage-secret
        key: AZURE_STORAGE_CONNECTION_STRING
  - name: AZURE_STORAGE_ACCOUNT
    value: "storage-account-name"    # Replace with actual value
  - name: AZURE_CONTAINER_NAME
    value: "container-name"          # Replace with actual value
````

## Deployment Steps

1. **Deploy the Backend:**
   ```bash
   kubectl apply -f backend-deployment.yaml
   ```

2. **Deploy the Frontend:**
   ```bash
   kubectl apply -f frontend-deployment.yaml
   ```

3. **(Optional) Deploy the Ingress:**
   If you need to expose the backend externally:
   ```bash
   kubectl apply -f backend-ingress.yaml
   ```

## Verification

After applying the manifests, check the status of your resources:

- **Pods:**
  ```bash
  kubectl get pods
  ```
- **Services:**
  ```bash
  kubectl get svc
  ```
- **Ingress (if applied):**
  ```bash
  kubectl get ingress
  ```

## Notes

- The **frontend** service is exposed via a LoadBalancer.
- The **backend** service typically runs as a ClusterIP and can be accessed internally by the frontend or externally via the Ingress (if configured).
- QR code images are stored in Azure Blob Storage
- Ensure your Azure Storage container has public (blob) access enabled if you plan to retrieve generated QR code images directly from a browser.
- Update image tags and other configuration as needed when versioning or deploying updates.

## Troubleshooting

- **Blob Not Accessible (404 Error):**  
  Verify that the QR code image has been uploaded to the correct folder and that the file path in the application matches the Azure Storage folder structure.
- **Pod/Deployment Issues:**  
  Use pod logs:
  ```bash
  kubectl logs <pod-name>
  ```
  to diagnose any errors.

This README file serves as a quick reference for understanding and deploying the Kubernetes manifests in this module.
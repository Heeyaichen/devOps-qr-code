# Kubernetes Manifests

This directory contains Kubernetes manifests for deploying the QR Code Generator application.

## Contents

- **azure-storage-secret.yaml**  
  - Defines a Kubernetes Secret to store Azure Storage credentials used for uploading QR code images.
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
- Base64-encoded Azure Storage credentials.

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

Before deploying the application, update the `azure-storage-secret.yaml` file with your base64-encoded values of your Azure credentials. For example, to encode a value in PowerShell you can use:
```powershell
[Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes("your-value"))
```
or in Bash:
```bash
echo -n "your-value" | base64
```
Apply the secret with:
```bash
kubectl apply -f azure-storage-secret.yaml
```

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
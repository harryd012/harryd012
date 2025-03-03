# Azure Kubernetes Services (AKS) - Kubernetes YAML Files

This repository contains YAML configuration files for services deployed on Azure Kubernetes Service (AKS). These files are stored for version control, collaboration, and Continuous Integration/Continuous Deployment (CI/CD) purposes.

## Purpose

The main goal of this repository is to provide a version-controlled place to store the configuration files of the AKS setup. This allows:

- **Tracking Changes**: Changes to Kubernetes deployments, services, and other resources can be tracked in version control.
- **Collaboration**: Team members can work together on the AKS configuration files.
- **Automation**: Through CI/CD pipelines, Kubernetes resources can be automatically deployed from GitHub to AKS.

## Repository Contents

The repository contains the following Kubernetes YAML files:

- **`deployments.yaml`**: Kubernetes deployments for different applications and services in the AKS cluster.
- **`services.yaml`**: Service definitions for exposing applications in the AKS cluster.
- **`pods.yaml`**: YAML definition for the Pods running on the AKS cluster.
- **`configmaps.yaml`**: Kubernetes ConfigMap definitions.
- **`secrets.yaml`**: Kubernetes Secrets for sensitive information (if available).

Feel free to update the repository with additional YAML files or configurations as needed.

## Prerequisites

Before working with this repository, make sure you have the following tools installed on your local machine:

- **Azure CLI**: To interact with Azure services.
- **kubectl**: Kubernetes command-line tool to interact with the AKS cluster.
- **Git**: Version control system to manage this repository.

## Setting Up the Repository Locally

Follow these steps to clone the repository and set up your local development environment:

1. Clone the repository to your local machine:
    ```bash
    git clone https://github.com/<YourGitHubUsername>/<RepositoryName>.git
    cd <RepositoryName>
    ```

2. To interact with your AKS cluster, you need to get the credentials using Azure CLI:
    ```bash
    az aks get-credentials --resource-group <ResourceGroupName> --name <AKSClusterName>
    ```

3. Once you've set up the credentials, you can use `kubectl` to interact with your AKS cluster.

4. Export your Kubernetes configurations as YAML files:
    ```bash
    kubectl get deployments --all-namespaces -o yaml > deployments.yaml
    kubectl get services --all-namespaces -o yaml > services.yaml
    kubectl get pods --all-namespaces -o yaml > pods.yaml
    kubectl get configmaps --all-namespaces -o yaml > configmaps.yaml
    ```

5. Add these files to the repository:
    ```bash
    git add .
    git commit -m "Add initial AKS YAML configurations"
    git push origin main
    ```

## Using the YAML Files for CI/CD

This repository can be integrated with CI/CD pipelines, such as **GitHub Actions** or **Azure Pipelines**, to deploy the YAML configurations directly to AKS. Here is an example of how you might set up a GitHub Action workflow:

### Example GitHub Actions Workflow:

```yaml
name: Deploy to AKS

on:
  push:
    branches:
      - main

jobs:
  deploy:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout repository
      uses: actions/checkout@v2

    - name: Set up Azure CLI
      uses: azure/setup-azurecli@v1

    - name: Login to Azure
      run: |
        az login --service-principal -u ${{ secrets.AZURE_CLIENT_ID }} -p ${{ secrets.AZURE_CLIENT_SECRET }} --tenant ${{ secrets.AZURE_TENANT_ID }}

    - name: Deploy to AKS
      run: |
        az aks get-credentials --resource-group <ResourceGroupName> --name <AKSClusterName>
        kubectl apply -f ./deployments.yaml
        kubectl apply -f ./services.yaml
        kubectl apply -f ./pods.yaml

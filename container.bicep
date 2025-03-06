param location string = 'westus'
param storageAccountName string = 'sta${uniqueString(resourceGroup().id)}'
param containerName string = 'container012'
param acrName string = 'acr${uniqueString(resourceGroup().id)}' // Valid ACR name
param aksName string = 'aks0123'
param aksNodepoolName string = 'nodepool0123'

resource aks 'Microsoft.ContainerService/managedClusters@2021-08-01' = {
  name: aksName
  location: location
  identity: { type: 'SystemAssigned' }
  properties: {
    kubernetesVersion: '1.30.0'
    dnsPrefix: 'aks0123-dns'
    nodeResourceGroup: 'aks-node-rg'
    enableRBAC: true
    agentPoolProfiles: [{
      name: aksNodepoolName
      count: 2
      vmSize: 'Standard_DS2_v2'
      osDiskSizeGB: 128
      type: 'VirtualMachineScaleSets'
      minCount: 1
      maxCount: 2
      enableAutoScaling: true
      mode: 'System'
    }]
  }
}

resource acr 'Microsoft.ContainerRegistry/registries@2021-09-01' = {
  name: acrName
  location: location
  sku: { name: 'Basic' }
  properties: { adminUserEnabled: false }
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-06-01' = {
  name: storageAccountName
  location: location
  sku: { name: 'Standard_LRS' }
  kind: 'StorageV2'
}

resource blobService 'Microsoft.Storage/storageAccounts/blobServices@2021-06-01' = {
  name: 'default'
  parent: storageAccount
}


resource container 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-06-01' = {
  name: containerName
  parent: blobService
  properties: {}
}

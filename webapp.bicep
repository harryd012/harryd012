param location string = 'southcentralus'
param storageAccountName string = 'sta01234'
param blobName string = 'blob01'
param packageUri string = 'https://humankind01.com/app01.zip'
param appServicePlanId string
@secure()
param adminPassword string
param adminUsername string = 'adminUser'
param vmLocation string = resourceGroup().location

// Web App
resource webApp 'Microsoft.Web/sites@2021-02-01' = {
  name: 'app012'
  location: location
  properties: {
    serverFarmId: appServicePlanId
    hostingEnvironmentProfile: {
      id: ''
    }
        siteConfig: {
      appSettings: [
        {
          name: 'APP_SETTING'
          value: 'value'
        }
      ]
    }
  }
}

// Web App Deployment (MSDeploy)
resource webApplicationExtension 'Microsoft.Web/sites/extensions@2020-12-01' = {
  parent: webApp
  name: 'MSDeploy'
  properties: {
    packageUri: packageUri
    dbType: 'None'
    connectionString: ''
    setParameters: {
      'IIS Web Application Name': 'app01'
    }
  }
}

// Storage Account
resource storageAccount 'Microsoft.Storage/storageAccounts@2021-04-01' = {
  name: storageAccountName
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
}

// Blob Service
resource blobService 'Microsoft.Storage/storageAccounts/blobServices@2021-04-01' = {
  parent: storageAccount
  name: 'default'
}

// Storage Container
resource storageContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-04-01' = {
  parent: blobService
  name: 'mycontainer'
  properties: {
    publicAccess: 'None'
  }
}

// Storage Blob
resource storageBlob 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-04-01' = {
  parent: blobService
  name: blobName
  properties: {
    metadata: {
      sourceUri: packageUri
    }
  }
}

// Virtual Network
resource virtualNetwork 'Microsoft.Network/virtualNetworks@2021-02-01' = {
  name: 'vnet01'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: ['10.0.0.0/16']
    }
    subnets: [
      {
        name: 'subnet01'
        properties: {
          addressPrefix: '10.0.1.0/24'
        }
      }
    ]
  }
}

// Network Interface
resource networkInterface 'Microsoft.Network/networkInterfaces@2021-02-01' = {
  name: 'nic01'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig01'
        properties: {
           subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', 'vnet01', 'subnet01')
          }
          privateIPAllocationMethod: 'Dynamic'
        }
      }
    ]
  }
}

// Virtual Machine
resource vm 'Microsoft.Compute/virtualMachines@2021-07-01' = {
  name: 'vm01'
  location: location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_DS1_v2'
    }
    osProfile: {
      adminUsername: adminUsername
       adminPassword: adminPassword
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2019-Datacenter'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterface.id
        }
      ]
    }
  }
}

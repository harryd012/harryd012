// Define the parameters for the resource group
param location string = 'uaenorth'


// Define the App Service Plan (F1 - Free tier)
var appServiceSku = {
    name: 'S1'
        capacity: 1
    }

resource appServicePlan 'Microsoft.Web/serverFarms@2021-02-01' = {
  name: 'webapp0123' // Must be globally unique
  location: location
  sku: appServiceSku
}

resource webApp 'Microsoft.Web/sites@2021-02-01' = {
  name: 'webapp0123' // Must be globally unique
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      linuxFxVersion: 'visualstudiocode'
    }
  }
  identity: {
    type: 'SystemAssigned' // Enable system-assigned managed identity
  }
}


// Output the Web App URL
output webAppUrl string = webApp.properties.defaultHostName
resource storageAccount 'Microsoft.Storage/storageAccounts@2021-04-01' = {
  name: 'sta2022' // Must be globally unique
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
}



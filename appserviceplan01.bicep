param location string = resourceGroup().location

resource appserviceplan01 'Microsoft.Web/serverfarms@2020-06-01' = {
  name: 'ASP-rg01-a970'
  location: location
  sku: {
    name: 'P1v2'
    capacity: 1
    tier: 'PremiumV2'
  }
  properties: {
    reserved: true
    perSiteScaling: false
    maximumElasticWorkerCount: 1
  }
}

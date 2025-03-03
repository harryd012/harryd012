param location string = resourceGroup().location
param githubRepo string = 'https://github.com/harryd012/harryd012.git'
param githubBranch string = 'main'
param githubToken string

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
resource webapp01 'Microsoft.Web/sites@2020-06-01' = {
  name: 'web'
  location: location
  properties: {
    serverFarmId: appserviceplan01.id
  }
}
resource webapp01_sourcecontrol 'Microsoft.Web/sites/sourcecontrols@2020-06-01' = {
  parent: webapp01
  name: 'web'
  properties: {
    repoUrl: githubRepo
    branch: githubBranch
    isManualIntegration: false
    deploymentRollbackEnabled: false
    isMercurial: false
    isGitHubAction: true
  }
}
resource githubtoken 'Microsoft.Web/sites/config@2020-06-01' = {
  parent: webapp01
  name: 'appsettings'
  properties: {
    appSettings: '[{"name": "GITHUB_TOKEN", "value": "${githubToken}"}]'
  }
}  

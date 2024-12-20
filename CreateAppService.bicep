param webAppName string =  'AzureDemoWebApplication'
param sku string = 'B1' // The SKU of App Service Plan
param linuxFxVersion string = 'node|20-lts' // The runtime stack of web app
param location string = resourceGroup().location // Location for all resources
// param repositoryUrl string = 'https://github.com/HimeEnthusiastProjects/AzureProject-WebApp'
// param branch string = 'master'
var appServicePlanName = toLower('AppServicePlan-${webAppName}')
var webSiteName = toLower('wapp-${webAppName}')

resource appServicePlan 'Microsoft.Web/serverfarms@2024-04-01' = {
  name: appServicePlanName
  location: location
  properties: {
    reserved: true
  }
  sku: {
    name: sku
  }
  kind: 'linux'
}

resource appService 'Microsoft.Web/sites@2024-04-01' = {
  name: webSiteName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    publicNetworkAccess: 'Enabled'
    httpsOnly: true
    siteConfig: {
      linuxFxVersion: linuxFxVersion
      metadata: [
        {
          name: 'CURRENT_STACK'
          value: 'node'
        }
      ]
    }
  }
}

// resource srcControls 'Microsoft.Web/sites/sourcecontrols@2024-04-01' = {
//   parent: appService
//   name: 'web'
//   properties: {
//     repoUrl: repositoryUrl
//     branch: branch
//     isManualIntegration: true
//   }
// }

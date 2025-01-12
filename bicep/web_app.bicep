@description('App Service SKU')
param appServiceSku string = 'B1'

@description('Deployment Location')
param deploymentLocation string = resourceGroup().location

@description('Database Server Host')
param databaseServerHost string

@description('Database Name')
param databaseName string

@description('Database Server Username')
param databaseServerUsername string

@description('Database Server Password')
@secure()
param databaseServerPassword string

@description('Web App Subnet Id')
param webAppSubnetId string

resource appServicePlan 'Microsoft.Web/serverfarms@2024-04-01' = {
  name: 'asp-cacn-demo-app-dev'
  location: deploymentLocation
  properties: {
    reserved: true
  }
  sku: {
    name: appServiceSku
  }
  kind: 'linux'
}

resource webApp 'Microsoft.Web/sites@2024-04-01' = {
  name: 'wa-cacn-demo-app-dev'
  location: deploymentLocation
  properties: {
    serverFarmId: appServicePlan.id
    publicNetworkAccess: 'Enabled'
    virtualNetworkSubnetId: webAppSubnetId
    httpsOnly: true
    siteConfig: {
      appSettings: [
        {
          name: 'DB_NAME'
          value: databaseName
        }
        {
          name: 'DB_PASS'
          value: databaseServerPassword
        }
        {
          name: 'DB_SERVER'
          value: databaseServerHost
        }
        {
          name: 'DB_USER'
          value: databaseServerUsername
        }
        {
          name: 'PORT'
          value: '8080'
        }
      ]
      linuxFxVersion: 'node|20-lts'
      metadata: [
        {
          name: 'CURRENT_STACK'
          value: 'node'
        }
      ]
    }
  }
}

@description('Server Host Name')
param serverHostName string

@description('Database Name')
param databaseName string

@description('Deployment Location')
param deploymentLocation string = resourceGroup().location

@description('Database Server Admin Username')
param databaseServerAdminUsername string

@description('Database Server Admin Password')
@secure()
param databaseServerAdminPassword string

@description('Database Subnet Id')
param databaseSubnetId string

@description('Database Server Private IP Address')
param privateIpAddress string

var privateEndpointName = 'pe-${serverHostName}'
var networkInterfaceCardName = 'nic-${serverHostName}'

resource azureSqlServer 'Microsoft.Sql/servers@2022-05-01-preview' = {
  name: serverHostName
  location: deploymentLocation
  properties: {
    administratorLogin: databaseServerAdminUsername
    administratorLoginPassword: databaseServerAdminPassword
    publicNetworkAccess: 'Disabled'
    minimalTlsVersion: '1.3'
  }
}

resource azureSqlDatabase 'Microsoft.Sql/servers/databases@2022-05-01-preview' = {
  parent: azureSqlServer
  name: databaseName
  location: deploymentLocation
  sku: {
    name: 'Basic'
    tier: 'Basic'
    size: '2GB'
  }
}

resource privateEndpoint 'Microsoft.Network/privateEndpoints@2024-05-01' = {
  name: privateEndpointName
  location: deploymentLocation
  properties: {
    customNetworkInterfaceName: networkInterfaceCardName 
    ipConfigurations: [
      {
        name: 'sqlServerIpConfig'
        properties: {
          groupId: 'sqlServer'
          memberName: 'sqlServer'
          privateIPAddress: privateIpAddress
        }
      }
    ]
    subnet: { id: databaseSubnetId }
    privateLinkServiceConnections: [
      {
        name: privateEndpointName
        properties: {
          privateLinkServiceId: azureSqlServer.id
          groupIds: ['sqlServer']
        }
      }
    ]
  }
}

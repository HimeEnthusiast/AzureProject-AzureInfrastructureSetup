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

@description('Database Subnet Name')
param databaseSubnetName string

@description('Database Server Private IP Address')
param privateIpAddress string

resource azureSqlServer 'Microsoft.Sql/servers@2022-05-01-preview' = {
  name: serverHostName
  location: deploymentLocation
  properties: {
    administratorLogin: databaseServerAdminUsername
    administratorLoginPassword: databaseServerAdminPassword
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

resource databaseSubnet 'Microsoft.Network/virtualNetworks/subnets@2021-05-01' existing = {
  name: databaseSubnetName
}

resource privateEndpoint 'Microsoft.Network/privateEndpoints@2024-05-01' = {
  name: 'pe-${serverHostName}'
  location: deploymentLocation
  properties: {
    customNetworkInterfaceName: 'nic-${serverHostName}'
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
    subnet: {
      id: databaseSubnet.id
    }
    privateLinkServiceConnections: [
      {
        name: 'pe-${serverHostName}'
        properties: {
          privateLinkServiceId: azureSqlServer.id
          groupIds: [
            'sqlServer'
          ]
        }
      }
    ]
  }
  dependsOn: [ databaseSubnet ]
}

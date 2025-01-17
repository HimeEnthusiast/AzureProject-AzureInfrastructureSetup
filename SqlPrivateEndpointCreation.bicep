@description('Location')
param location string = resourceGroup().location

param vnetName string = 'VN_AzureBicepApplicationDeployment'

param privateEndpointName string = 'PE_SqlServerVirtualNetworkConnection'

var subnetPrefix = '10.0.0.0/24'
var subnetName = 'SN_DatabaseSubnet'

@description('SQL server name')
param serverName string = 'sql1357924680'

param privateDnsZoneName string = 'privatelink${environment().suffixes.sqlServerHostname}'

resource vnet 'Microsoft.Network/virtualNetworks@2023-11-01' existing = {
  name: vnetName
}

resource sqlServer 'Microsoft.Sql/servers@2022-05-01-preview' existing = {
  name: serverName
}

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2021-05-01' = {
  parent: vnet
  name: subnetName
  properties: {
    addressPrefix: subnetPrefix
    privateEndpointNetworkPolicies: 'Disabled'
  }
}

param privateEndpointIP string
var privateEndpointNicName = 'NI_AzureApplicationSqlNic'

resource privateDnsZone 'Microsoft.Network/privateDnsZones@2024-06-01' existing = {
  name: privateDnsZoneName
}

// Set up private endpoint for SQL Server
resource privateEndpoint 'Microsoft.Network/privateEndpoints@2024-05-01' = {
  name: privateEndpointName
  location: location
  properties: {
    customNetworkInterfaceName: privateEndpointNicName
    ipConfigurations: [
      {
        name: 'sqlServerIpConfig'
        properties: {
          groupId: 'sqlServer'
          memberName: 'sqlServer'
          privateIPAddress: privateEndpointIP
        }
      }
    ]
    subnet: {
      id: subnet.id
    }
    privateLinkServiceConnections: [
      {
        name: privateEndpointName
        properties: {
          privateLinkServiceId: sqlServer.id
          groupIds: [
            'sqlServer'
          ]
        }
      }
    ]
  }
  dependsOn: [
    vnet
  ]

  resource privateEndpointDnsZoneGroup 'privateDnsZoneGroups@2024-05-01' = {
    name: 'sqlServerPrivateEndpointDnsZoneGroup'
    properties: {
      privateDnsZoneConfigs: [
        {
          name: 'privateEndpointPrivateGroupName'
          properties: {
            privateDnsZoneId: privateDnsZone.id
          }
        }
      ]
    }
  }
}

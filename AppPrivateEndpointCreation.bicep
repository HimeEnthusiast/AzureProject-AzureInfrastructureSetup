@description('Location')
param location string = resourceGroup().location

param vnetName string = 'VN_AzureBicepApplicationDeployment'

param privateEndpointName string = 'PE_WebAppVirtualNetworkConnection'

var webAppName = 'AzureDemoWebApplication'

// var subnet1Prefix = '10.0.0.0/24'
var subnetName = 'SN_WebAppSubnet'

// @description('SQL server name')
// param serverName string = 'sql1357924680'

resource vnet 'Microsoft.Network/virtualNetworks@2023-11-01' existing = {
  name: vnetName
}

resource webApp 'Microsoft.Web/sites@2024-04-01' existing = {
  name: webAppName
}

// resource sqlServer 'Microsoft.Sql/servers@2022-05-01-preview' existing = {
//   name: serverName
// }

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2021-05-01'  = {
  name: subnetName
}

param privateEndpointIP string
var privateEndpointNicName = 'AzureApplicationWebAppNic'

// Set up private endpoint for Web App
resource privateEndpoint 'Microsoft.Network/privateEndpoints@2021-05-01' = {
  name: privateEndpointName
  location: location
  properties: {
    customNetworkInterfaceName: privateEndpointNicName
    ipConfigurations: [
      {
        name: 'ipConfig'
        properties: {
          groupId: 'webApp'
          memberName: 'webApp'
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
          privateLinkServiceId: webApp.id
          groupIds: [
            'webApp'
          ]
        }
      }
    ]
  }
  dependsOn: [
    vnet
  ]
}

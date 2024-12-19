@description('Location')
param location string = resourceGroup().location

param vnetName string = 'VN_AzureBicepApplicationDeployment'

param privateEndpointName string = 'PE_WebAppVirtualNetworkConnection'

var webAppName = 'wapp-AzureDemoWebApplication'

var subnetPrefix = '10.0.1.0/24'
var subnetName = 'SN_WebAppSubnet'

// @description('SQL server name')
// param serverName string = 'sql1357924680'

resource vnet 'Microsoft.Network/virtualNetworks@2023-11-01' existing = {
  name: vnetName
}

resource webApp 'Microsoft.Web/sites@2024-04-01' existing = {
  name: webAppName
}

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2021-05-01'  = {
    parent: vnet
    name: subnetName
    properties: {
      addressPrefix: subnetPrefix
      privateEndpointNetworkPolicies: 'Disabled'
      delegations: [
        {
          name: 'webAppsDelegation'
          properties: {
            serviceName: 'Microsoft.Web/serverFarms'
          }
        }
      ]
    }
}

param privateEndpointIP string
var privateEndpointNicName = 'NI_AzureApplicationWebAppNic'

// Set up private endpoint for Web App
resource privateEndpoint 'Microsoft.Network/privateEndpoints@2024-05-01' = {
  name: privateEndpointName
  location: location
  properties: {
    customNetworkInterfaceName: privateEndpointNicName
    ipConfigurations: [
      {
        name: 'webAppIpConfig'
        properties: {
          groupId: 'sites'
          memberName: 'sites'
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
            'sites'
          ]
        }
      }
    ]
  }
  dependsOn: [
    vnet
  ]
}

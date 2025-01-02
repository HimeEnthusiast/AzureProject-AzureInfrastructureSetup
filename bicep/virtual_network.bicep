@description('Address Prefix')
param addressPrefix string = '10.0.0.0/16'

@description('Deployment Location')
param deploymentLocation string = resourceGroup().location

resource deploymentVirtualNetwork 'Microsoft.Network/virtualNetworks@2024-05-01' = {
	name: 'vnet-demo-app-cacn-dev'
	location: deploymentLocation
	properties: {
	  addressSpace: {
      addressPrefixes: [ addressPrefix ]
	  }
	}
}

resource webAppsSubnet 'Microsoft.Network/virtualNetworks/subnets@2021-05-01'  = {
  parent: deploymentVirtualNetwork 
  name: 'web-apps-subnet'
  properties: {
    addressPrefix: '10.0.1.0/24'
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

resource databaseSubnet 'Microsoft.Network/virtualNetworks/subnets@2021-05-01'  = {
  parent: deploymentVirtualNetwork 
  name: 'database-subnet'
  properties: {
    addressPrefix: '10.0.2.0/24'
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

output virtualNetworkName string = deploymentVirtualNetwork.name
output databaseSubnetName string = databaseSubnet.name
output webAppSubnetName string = webAppsSubnet.name

targetScope = 'resourceGroup'

@description('Resour Group Name')
param resourceGroupName string = resourceGroup().name

@description('Location')
param deploymentLocation string = resourceGroup().location

module virutalNetwork './virtual_network.bicep' = {
  name: 'virtualNetworkDeploy'
  params: {
    addressPrefix: '10.0.0.0/16'
    deploymentLocation: deploymentLocation
  }
}

module privateDnsZones './private_dns.bicep' = {
  name: 'privateDnsZoneDeploy'
  params {
    virtualNetworkName: virutalNetwork.name
    deploymentLocation: deploymentLocation
    databaseDnsRecord: 'mydbname.database.windows.net'
    databaseStaticIpAddress: '10.0.2.5'
  }
}

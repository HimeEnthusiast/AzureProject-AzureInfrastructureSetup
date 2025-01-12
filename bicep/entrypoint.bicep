targetScope = 'resourceGroup'

@description('Location')
param deploymentLocation string = resourceGroup().location

@description('Database Server Host Name')
param databaseServerHostName string

@description('Database Name')
param databaseName string

@description('Database Server Admin Username')
param databaseServerAdminUsername string

@description('Database Server Admin Username')
@secure()
param databaseServerAdminPassword string

var databaseServerPrivateIpAddress = '10.0.2.5'

module virutalNetwork './virtual_network.bicep' = {
  name: 'virtualNetworkDeploy'
  params: {
    addressPrefix: '10.0.0.0/16'
    deploymentLocation: deploymentLocation
  }
}

module azureSql './database.bicep' = {
  name: 'databaseDeploy'
  params: {
    serverHostName: databaseServerHostName
    databaseName: databaseName
    deploymentLocation: deploymentLocation
    databaseServerAdminUsername: databaseServerAdminUsername
    databaseServerAdminPassword: databaseServerAdminPassword
    databaseSubnetId: virutalNetwork.outputs.databaseSubnetId
    privateIpAddress: databaseServerPrivateIpAddress
  }
}

module webApp './web_app.bicep' = {
  name: 'webAppDeploy'
  params: {
    appServiceSku: 'B1'
    deploymentLocation: deploymentLocation
    databaseServerHost: 'databaseServerHostName${environment().suffixes.sqlServerHostname}'
    databaseName: databaseName
    databaseServerUsername: databaseServerAdminUsername
    databaseServerPassword: databaseServerAdminPassword
    webAppSubnetId: virutalNetwork.outputs.webAppSubnetId
  }
}

module privateDnsZones './private_dns.bicep' = {
  name: 'privateDnsZoneDeploy'
  params: {
    virtualNetworkName: virutalNetwork.outputs.virtualNetworkName
    deploymentLocation: deploymentLocation
    databaseServerHostName: databaseServerHostName
    databaseStaticIpAddress: databaseServerPrivateIpAddress
  }
}

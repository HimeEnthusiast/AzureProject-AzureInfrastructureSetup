@description('Virtual Network Name')
param virtualNetworkName string

@description('Deployment Location')
param deploymentLocation string

@description('Database DNS Record')
param databaseServerHostName string

@description('Database Static IP Address')
param databaseStaticIpAddress string

resource deploymentVirtualNetwork 'Microsoft.Network/virtualNetworks@2024-05-01' existing = {
  name: virtualNetworkName
}

resource databasePrivateDnsZone 'Microsoft.Network/privateDnsZones@2024-06-01' = {
  location: deploymentLocation
  name: 'privatelink.${environment().suffixes.sqlServerHostname}'
  properties: {}

  resource dbDnsRecord 'A' = {
    name: '${databaseServerHostName}.${environment().suffixes.sqlServerHostname}'
    properties: {
      ttl: 3600
      aRecords: [ { ipv4Address: databaseStaticIpAddress } ]
    }
  }
}

resource dnsZoneToVnet 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2024-06-01' = {
  parent: databasePrivateDnsZone
  name: 'database-dns-link'
  location: deploymentLocation
  properties: {
    registrationEnabled: false
    virtualNetwork: { id: deploymentVirtualNetwork.id }
  }
}

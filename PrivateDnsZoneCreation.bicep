param vnetName string = 'VN_AzureBicepApplicationDeployment'

param location string = 'global'
param privateDnsZoneName string = 'privatelink${environment().suffixes.sqlServerHostname}'

param dnsZoneToVnetName string = 'link_to_vnet'

param dbDnsRecordName string = 'sql1357924680${environment().suffixes.sqlServerHostname}'
param dbIpAddress string

resource vnet 'Microsoft.Network/virtualNetworks@2024-05-01' existing = {
  name: vnetName
}

resource privateDnsZone 'Microsoft.Network/privateDnsZones@2024-06-01' = {
  location: location
  name: privateDnsZoneName
  properties: {}

  resource dbDnsRecord 'A' = {
    name: dbDnsRecordName
    properties: {
      ttl: 3600
      aRecords: [
        {
          ipv4Address: dbIpAddress
        }
      ]
    }
  }
}

resource dnsZoneToVnet 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2024-06-01' = {
  parent: privateDnsZone
  name: dnsZoneToVnetName
  location: location
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: vnet.id
    }
  }
}

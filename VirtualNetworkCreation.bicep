@description('Address prefix')
param addressPrefix string = '10.0.0.0/16'

@description('Location')
param location string = resourceGroup().location

resource DeploymentProjectVirtualNetwork 'Microsoft.Network/virtualNetworks@2024-05-01' = {
	name: 'VN_AzureBicepApplicationDeployment'
	location: location
	properties: {
	  addressSpace: {
		addressPrefixes: [
			addressPrefix
		]
	  }
	}
  }

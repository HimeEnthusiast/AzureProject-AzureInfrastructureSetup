targetScope='subscription'

@description('Resour Group Name')
param rgName string = 'RG_AzureBicepApplicationDeployment'

@description('Location')
param rgLocation string = 'canadacentral'

resource DeploymentProjectResourseGroup 'Microsoft.Resources/resourceGroups@2024-03-01' = {
	name: rgName
  	location: rgLocation
}

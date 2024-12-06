$groupName = "RG_AzureBicepApplicationDeployment"
$location = "CanadaCentral"
$adminDbPass = "MeowMeowMeow123!!"

az account set --subscription "BellaFirstSubscription"

az deployment sub create `
--location $location `
--template-file .\ResourceGroupCreation.bicep

az deployment group create `
--resource-group $groupName `
--template-file .\VirtualNetworkCreation.bicep

az deployment group create `
--resource-group $groupName `
--parameters administratorLoginPassword=$adminDbPass `
--template-file .\SqlDatabaseCreation.bicep

az deployment group create `
--resource-group $groupName `
--parameters privateEndpointIP='10.0.0.8' `
--template-file .\PrivateEndpointCreation.bicep

az deployment group create `
--resource-group $groupName `
--template-file .\CreateAppService.bicep
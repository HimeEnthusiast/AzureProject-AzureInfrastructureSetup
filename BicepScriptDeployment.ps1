$groupName = "RG_AzureBicepApplicationDeployment"
$location = "CanadaCentral"
$adminDbPass = "MeowMeowMeow123!!"
$subnetName = "mySubnet"
$vnetName = 'VN_AzureBicepApplicationDeployment'


# Write-Output Set account to BellaFirstSubscription
# az account set --subscription "BellaFirstSubscription"

# Write-Output Create Resource Group
# az deployment sub create `
# --location $location `
# --template-file .\ResourceGroupCreation.bicep

# Write-Output Create virtual network
# az deployment group create `
# --resource-group $groupName `
# --template-file .\VirtualNetworkCreation.bicep

# Write-Output Create SQL Server and Database
# az deployment group create `
# --resource-group $groupName `
# --parameters administratorLoginPassword=$adminDbPass `
# --template-file .\SqlDatabaseCreation.bicep

# Write-Output Create private endpoint for SQL server
# az deployment group create `
# --resource-group $groupName `
# --parameters privateEndpointIP='10.0.0.8' `
# --template-file .\SqlPrivateEndpointCreation.bicep

# Write-Output Create app service for web app deployment
# az deployment group create `
# --resource-group $groupName `
# --template-file .\CreateAppService.bicep

Write-Output Create private endpoint for app service
az deployment group create `
--resource-group $groupName `
--parameters privateEndpointIP='10.0.1.9' `
--template-file .\AppPrivateEndpointCreation.bicep
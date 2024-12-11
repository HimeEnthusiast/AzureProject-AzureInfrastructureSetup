$groupName = "RG_AzureBicepApplicationDeployment"
$location = "CanadaCentral"
$adminDbPass = "MeowMeowMeow123!!"
$subnetName = "mySubnet"
$vnetName = 'VN_AzureBicepApplicationDeployment'
$nsgName = "actions_NSG"
$subscriptionId = "634787db-0332-4328-aa6d-ec43aed7e3c1"
$API_VERSION = 2024-04-02

Write-Output Set account to BellaFirstSubscription
az account set --subscription "BellaFirstSubscription"

Write-Output Create Resource Group
az deployment sub create `
--location $location `
--template-file .\ResourceGroupCreation.bicep

Write-Output Create network security group rules
az deployment group create `
--resource-group $groupName `
--parameters location=$location `
--template-file .\ActionsNsgDeployment.bicep

Write-Output Delegate subnet to GitHub.Network/networkSettings and apply NSG rules
az network vnet subnet update `
--resource-group $groupName `
--name $subnetName `
--vnet-name $vnetName `
--delegations GitHub.Network/networkSettings `
--network-security-group $nsgName

Write-Output Create virtual network
az deployment group create `
--resource-group $groupName `
--template-file .\VirtualNetworkCreation.bicep

Write-Output Create SQL Server and Database
az deployment group create `
--resource-group $groupName `
--parameters administratorLoginPassword=$adminDbPass `
--template-file .\SqlDatabaseCreation.bicep

Write-Output Create private endpoint for SQL server
az deployment group create `
--resource-group $groupName `
--parameters privateEndpointIP='10.0.0.8' `
--template-file .\SqlPrivateEndpointCreation.bicep

Write-Output Create app service for web app deployment
az deployment group create `
--resource-group $groupName `
--template-file .\CreateAppService.bicep

Write-Output Create private endpoint for app service
az deployment group create `
--resource-group $groupName `
--parameters privateEndpointIP='10.0.0.9' `
--template-file .\AppPrivateEndpointCreation.bicep

Write-Output Create network settings resource
az resource create `
--resource-group $groupName `
--name $nsgName `
--resource-type GitHub.Network/networkSettings `
--properties "{ \"location\": \"$location\", \"properties\" : { \"subnetId\": \"/subscriptions/$subscriptionId/resourceGroups/$groupName/providers/Microsoft.Network/virtualNetworks/$vnetName/subnets/$subnetName `
--output table `
--query "{GitHubId:tags.GitHubId, name:name}" `
--api-version $API_VERSION
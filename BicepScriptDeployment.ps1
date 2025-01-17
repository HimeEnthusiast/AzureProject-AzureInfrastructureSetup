$groupName = "RG_AzureBicepApplicationDeployment"
$location = "CanadaCentral"
$adminDbPass = "MeowMeowMeow123!!"
$serverName = "sql1357924680"


Write-Output Set account to BellaFirstSubscription
az account set --subscription "BellaFirstSubscription"

Write-Output Create Resource Group
az deployment sub create `
--location $location `
--template-file .\ResourceGroupCreation.bicep

Write-Output Create virtual network
az deployment group create `
--resource-group $groupName `
--template-file .\VirtualNetworkCreation.bicep

Write-Output Set up private DNS zone
az deployment group create `
--resource-group $groupName `
--parameters dbIpAddress='10.0.0.8' `
--template-file .\PrivateDnsZoneCreation.bicep

Write-Output Create SQL server and database
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
--parameters dbPass=$adminDbPass `
--template-file .\CreateAppService.bicep

Write-Output Create subnet for app service
az deployment group create `
--resource-group $groupName `
--template-file .\AppPrivateEndpointCreation.bicep

Write-Output Allow Home IP to access SQL server
az sql server firewall-rule create `
--name AllowHome `
--resource-group $groupName `
--server $serverName `
--start-ip-address 99.253.102.25 `
--end-ip-address 99.253.102.25
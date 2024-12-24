# [ Pipeline Level Variables ]
# $AZURE_SUBSCRIPTION
# $RESOURCE_GROUP_NAME
# $DEPLOYMENT_LOCATION
# $AZURE_SQL_HOST_NAME
# $AZURE_SQL_ADMIN_USERNAME
#
# [ Pipeline Level Secrets ]
# $AZURE_SQL_ADMIN_PASSWORD

az account set --subscription $AZURE_SUBSCRIPTION

Write-Output "Creating \"$RESOURCE_GROUP_NAME\" within subscription \"$AZURE_SUBSCRIPTION\""
az group create --name $RESOURCE_GROUP_NAME --location $DEPLOYMENT_LOCATION
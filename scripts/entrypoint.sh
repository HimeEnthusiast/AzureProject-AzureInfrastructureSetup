#!/bin/bash

AZURE_SUBSCRIPTION="BellaFirstSubscription"
RESOURCE_GROUP_NAME="RG_AzureBicepApplicationDeployment"
DEPLOYMENT_LOCATION="CanadaCentral"

DATABASE_SERVER_ADMIN_PASSWORD="MeowMeowMeow123!!"

az account set --subscription $AZURE_SUBSCRIPTION

az group create --name $RESOURCE_GROUP_NAME --location $DEPLOYMENT_LOCATION

az deployment group create \
--name LocalDeployment \
--resource-group $RESOURCE_GROUP_NAME \
--template-file ./bicep/entrypoint.bicep \
--parameters deploymentLocation=$DEPLOYMENT_LOCATION \
--parameters databaseServerHostName="azsql-cacn-demo-app-dev" \
--parameters databaseName="food_catalog" \
--parameters databaseServerAdminUsername="root_admin_demo_app" \
--parameters databaseServerAdminPassword=$DATABASE_SERVER_ADMIN_PASSWORD
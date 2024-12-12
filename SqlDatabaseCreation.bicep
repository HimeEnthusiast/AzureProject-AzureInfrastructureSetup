@description('SQL server name')
param serverName string = 'sql1357924680'

@description('SQL database name')
param sqlDBName string = 'DB_AzureBicepApplicationDevelopment'

@description('Location')
param location string = resourceGroup().location

@description('The admin username of the SQL server')
param administratorLogin string = 'user'

@description('The admin password of the SQL server')
@secure()
param administratorLoginPassword string

// Creates SQL Server
resource sqlServer 'Microsoft.Sql/servers@2022-05-01-preview' = {
  name: serverName
  location: location
  properties: {
    
    // publicNetworkAccess: 'Disabled'
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorLoginPassword
  }
}

// Creates DB within server
resource sqlDB 'Microsoft.Sql/servers/databases@2022-05-01-preview' = {
  parent: sqlServer
  name: sqlDBName
  location: location
  sku: {
    name: 'Basic'
    tier: 'Basic'
    size: '2GB'
  }
}

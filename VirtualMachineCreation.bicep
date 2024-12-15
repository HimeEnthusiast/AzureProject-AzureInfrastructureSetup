@description('Location')
param location string = resourceGroup().location


//public IP

//Network Security Group

//Subnet

//Private Endpoint

//Nic

resource VmSelfHostedRunner 'Microsoft.Compute/virtualMachines@2024-07-01' = {
  location: location
  name: 'VM_SelfHostedRunner'
  properties: {
    
  }
}

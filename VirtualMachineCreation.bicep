@description('Location')
param location string = resourceGroup().location

//public IP
resource publicIp 'Microsoft.Network/publicIPAddresses@2022-05-01' = {
  name: 'IP_selfHostedRunner'
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Dynamic'
  }
}

//Network Security Group
resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2022-05-01' = {
  name: 'NSG_selfHostedRunner'
  location: location
  properties: {
    securityRules: [
      {
        name: 'SSH'
        properties: {
          priority: 300
          access: 'Allow'
          direction: 'Inbound'
          destinationPortRange: '22'
          protocol: 'Tcp'
          sourcePortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
        }
      }
    ]
  }
}

//Subnet

//Private Endpoint

//Nic

resource VmSelfHostedRunner 'Microsoft.Compute/virtualMachines@2024-07-01' = {
  location: location
  name: 'VM-SelfHostedRunner'
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_B4ms'
    }
    osProfile: {
        computerName: vmName
        adminUsername: adminUsername
        adminPassword: adminPassword
    }
      storageProfile: {
        imageReference: {
          publisher: 'MicrosoftWindowsServer'
          offer: 'WindowsServer'
          sku: OSVersion
          version: 'latest'
        }
        osDisk: {
          createOption: 'FromImage'
          managedDisk: {
            storageAccountType: 'StandardSSD_LRS'
          }
        }
  }
}

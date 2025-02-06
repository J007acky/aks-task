targetScope = 'subscription'

@description('Resource group name')
param rgName string

@description('Location for resource group.')
param rgLocation string

resource resourceGroupAKS 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: '${rgName}-aks-rg'
  location: rgLocation 
}

// resource resourceGroupVM 'Microsoft.Resources/resourceGroups@2021-04-01' = {
//   name: '${vmRGName}-vm-rg'
//   location: sharedLocation
// }

// resource resourceGroupIdentity 'Microsoft.Resources/resourceGroups@2021-04-01' = {
//   name: '${rgName}-identity-rg'
//   location: rgLocation
// }

output aksRG string = resourceGroupAKS.name

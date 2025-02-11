targetScope = 'subscription'

@description('Resource group name')
param rgName string

@description('Environment of the resources to be deployed in.')
param environment string

@description('Location for resource group.')
param rgLocation string

resource resourceGroupAKS 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: '${rgName}-aks-rg'
  location: rgLocation 
  tags: {
        environment: environment
        project: 'aks-task'
  }
}

output aksRG string = resourceGroupAKS.name

@description('Name of the AKS Managed Identity.')
param aksManagedIdentityName string

@description('Name of the AKS Managed Identity.')
param kubeletManagedIdentityName string

@description('Location of the Managed Identity.')
param location string = 'WestUS'

@description('Resource Group Name of the Virtual Network.')
param vNetName string

@description('Resource Group Name of the Virtual Network.')
param vnetResourceGroup string

resource aksVnet 'Microsoft.Network/virtualNetworks@2024-05-01' existing = {
  name: vNetName
  scope: resourceGroup(vnetResourceGroup)
}


@description('Managed Identity for AKS control plane to interact with other Azure resources.')
resource AksManagedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: aksManagedIdentityName
  location: location
}

@description('Managed Identity for Kubelet (Node Pool) to pull images and access Azure resources.')
resource KubeletManagedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: kubeletManagedIdentityName
  location: location
}

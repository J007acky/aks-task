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

// 🔹 AKS Managed Identity Role Assignments
@description('Assigns Azure Kubernetes Service Cluster User role to the AKS Managed Identity.')
resource aksClusterUserRoleAssignment 'Microsoft.Authorization/roleAssignments@2020-10-01-preview' = {
  // dependsOn: [
  //   AksManagedIdentity
  // ]
  name: guid(AksManagedIdentity.id, '4abbcc35-e782-43d8-92c5-2d3f1bd2253f') // AKS Cluster User Role
  properties: {
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', '4abbcc35-e782-43d8-92c5-2d3f1bd2253f')
    principalId: AksManagedIdentity.properties.principalId
    principalType: 'ServicePrincipal'
  }
  scope: subscription()
}

@description('Assigns Network Contributor role to AKS Managed Identity.')
resource networkContributorRoleAssignment 'Microsoft.Authorization/roleAssignments@2020-10-01-preview' = {
  dependsOn: [
    AksManagedIdentity
  ]
  name: guid(AksManagedIdentity.id, '4d97b98b-1d4f-4787-a291-c67834d212e7','Network Contributor') // Network Contributor Role
  properties: {
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', '4d97b98b-1d4f-4787-a291-c67834d212e7')
    principalId: AksManagedIdentity.properties.principalId
    principalType: 'ServicePrincipal'
  }
  scope: aksVnet
}

@description('Managed Identity Operator role to AKS Managed Identity.')
resource identityOperatorRoleAssignment 'Microsoft.Authorization/roleAssignments@2020-10-01-preview' = {
  // dependsOn: [
  //   AksManagedIdentity
  // ]
  name: guid(AksManagedIdentity.id, 'f1a07417-d97a-45cb-824c-7a7467783830') // Network Contributor Role
  properties: {
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', 'f1a07417-d97a-45cb-824c-7a7467783830')
    principalId: AksManagedIdentity.properties.principalId
    principalType: 'ServicePrincipal'
  }
  scope: resourceGroup()
}

// 🔹 Kubelet Managed Identity Role Assignments
// ACR Pull Role
// Azure Key Vault Secrets Role

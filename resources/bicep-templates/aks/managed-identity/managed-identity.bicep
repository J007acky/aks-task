@description('Name of the AKS managed identity.')
param aksManagedIdentityName string

@description('Name of the AKS managed identity.')
param kubeletManagedIdentityName string

@description('Location of the managed identity.')
param location string

@description('Managed Identity for AKS control plane.')
resource AksManagedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: aksManagedIdentityName
  location: location
}

@description('Managed Identity for Kubelet (Node Pool) to pull images and access Azure resources.')
resource KubeletManagedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: kubeletManagedIdentityName
  location: location
}

@description('Managed Identity Operator role to AKS Managed Identity.')
resource identityOperatorRoleAssignment 'Microsoft.Authorization/roleAssignments@2020-10-01-preview' = {
  name: guid(AksManagedIdentity.id, 'Managed Identity Operator')
  properties: {
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', 'Managed Identity Operator')
    principalId: AksManagedIdentity.properties.principalId
    principalType: 'ServicePrincipal'
  }
  scope: resourceGroup()
}

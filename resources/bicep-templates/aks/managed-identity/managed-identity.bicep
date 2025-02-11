@description('Name of the AKS managed identity.')
param aksManagedIdentityName string

@description('Name of the AKS managed identity.')
param kubeletManagedIdentityName string

@description('Location of the managed identity.')
param location string

@description('Environment of the resources to be deployed in.')
param environment string

@description('Managed Identity for AKS control plane.')
resource AksManagedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: aksManagedIdentityName
  location: location
  tags: {
        environment: environment
        project: 'aks-task'
  }
}

@description('Managed Identity for Kubelet (Node Pool) to pull images and access Azure resources.')
resource KubeletManagedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: kubeletManagedIdentityName
  location: location
  tags: {
        environment: environment
        project: 'aks-task'
  }
}

@description('Managed Identity Operator role to AKS Managed Identity.')
resource identityOperatorRoleAssignment 'Microsoft.Authorization/roleAssignments@2020-10-01-preview' = {
  name: guid(AksManagedIdentity.id, 'f1a07417-d97a-45cb-824c-7a7467783830')
  properties: {
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', 'f1a07417-d97a-45cb-824c-7a7467783830')
    principalId: AksManagedIdentity.properties.principalId
    principalType: 'ServicePrincipal'
  }
  scope: resourceGroup()
}

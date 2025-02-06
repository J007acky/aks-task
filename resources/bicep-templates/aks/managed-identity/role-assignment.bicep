@description('rgNamePrefix')
param rgNamePrefix string

var aksManagedIdentityId = '${rgNamePrefix}-identity-aks-managed-identity'

resource aksManagedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' existing = {
  scope: resourceGroup('${rgNamePrefix}-aks-rg')
  name: aksManagedIdentityId
}
// 🔹 AKS Managed Identity Role Assignments
@description('Assigns Azure Kubernetes Service Cluster User role to the AKS Managed Identity.')
resource aksClusterUserRoleAssignment 'Microsoft.Authorization/roleAssignments@2020-10-01-preview' = {
  // dependsOn: [
  //   AksManagedIdentity
  // ]
  name: guid(aksManagedIdentity.id, '4abbcc35-e782-43d8-92c5-2d3f1bd2253f') // AKS Cluster User Role
  properties: {
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', '4abbcc35-e782-43d8-92c5-2d3f1bd2253f')
    principalId: aksManagedIdentity.properties.principalId
    principalType: 'ServicePrincipal'
  }
  scope: resourceGroup()
}

@description('Assigns Network Contributor role to AKS Managed Identity.')
resource networkContributorRoleAssignment 'Microsoft.Authorization/roleAssignments@2020-10-01-preview' = {
  // dependsOn: [
  //   aksManagedIdentity
  // ]
  name: guid(aksManagedIdentity.id, '4d97b98b-1d4f-4787-a291-c67834d212e7','Network Contributor') // Network Contributor Role
  properties: {
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', '4d97b98b-1d4f-4787-a291-c67834d212e7')
    principalId: aksManagedIdentity.properties.principalId
    principalType: 'ServicePrincipal'
  }
  scope: resourceGroup()
}

@description('Managed Identity Operator role to AKS Managed Identity.')
resource identityOperatorRoleAssignment 'Microsoft.Authorization/roleAssignments@2020-10-01-preview' = {
  // dependsOn: [
  //   AksManagedIdentity
  // ]
  name: guid(aksManagedIdentity.id, 'f1a07417-d97a-45cb-824c-7a7467783830') // Network Contributor Role
  properties: {
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', 'f1a07417-d97a-45cb-824c-7a7467783830')
    principalId: aksManagedIdentity.properties.principalId
    principalType: 'ServicePrincipal'
  }
  scope: resourceGroup()
}

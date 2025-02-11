@description('rgNamePrefix')
param rgNamePrefix string

param roles array

var aksManagedIdentityId = '${rgNamePrefix}-identity-aks-managed-identity'



resource aksManagedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' existing = {
  scope: resourceGroup('${rgNamePrefix}-aks-rg')
  name: aksManagedIdentityId
}


resource roleAssign 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for role in roles: {
    name: guid(aksManagedIdentity.id, role)
    properties: {
      roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', role)
      principalId: aksManagedIdentity.properties.principalId
      principalType: 'ServicePrincipal'
    }
  }
]

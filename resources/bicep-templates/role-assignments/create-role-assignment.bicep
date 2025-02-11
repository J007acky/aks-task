targetScope = 'subscription'

@description('PrincipalIds of the user')
param userPrincipalId string

@description('Role Definition Ids of the roles to be assigned')
param roleDefinitionId string

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2020-08-01-preview' = {
  name: guid(subscription().id, userPrincipalId, roleDefinitionId)
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleDefinitionId)
    // roleDefinitionId: roleDefinitionId
    principalId: userPrincipalId
  }
}

output roleAssignmentId string = roleAssignment.id

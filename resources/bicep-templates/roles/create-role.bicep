targetScope = 'subscription'

param roles array

resource roleDefs 'Microsoft.Authorization/roleDefinitions@2022-04-01' = [
  for role in roles: {
    name: guid(role.roleName)
    properties: {
      roleName: role.roleName
      description: role.roleDescription
      type: 'customRole'
      permissions: [
        {
          actions: role.actions
          notActions: role.notActions
          dataActions: role.dataActions
          notDataActions: role.notDataActions
        }
      ]
      assignableScopes: [
        subscription().id
      ]
    }
  }
]

output roleNames array = [for (role, i) in roles: role.roleName]

output roleDefinitionIds array = [for (role, i) in roles: roleDefs[i].name]

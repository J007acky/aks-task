param location string = resourceGroup().location

var subscription_id = '8c01f775-0496-43bc-a889-65565e670e05'
var virtualNetworkName = '${subscription_id}-eastus-test-hub'
var addressSpace = '10.0.0.0/16'

var bastionSubnetPrefix = '10.0.1.0/24'
var resourceSubnetPrefix = '10.0.2.0/24'

resource hub_vnet 'Microsoft.Network/virtualNetworks@2023-11-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressSpace
      ]
    }
  }
}

resource bastion_subnet 'Microsoft.Network/virtualNetworks/subnets@2024-05-01' = {
  parent: hub_vnet
  name: 'AzureBastionSubnet'
  properties: {
    addressPrefix: bastionSubnetPrefix
    privateEndpointNetworkPolicies: 'Disabled'
    defaultOutboundAccess: false
  }
}

resource resource_subnet 'Microsoft.Network/virtualNetworks/subnets@2024-05-01' = {
  parent: hub_vnet
  name: 'resource-subnet'
  properties: {
    addressPrefix: resourceSubnetPrefix
    privateEndpointNetworkPolicies: 'Disabled'
    defaultOutboundAccess: false
  }
}

output deploymentName string = deployment().name
output hubVnetId string = hub_vnet.id
output hubVnetName string = hub_vnet.name
output bastionSubnetId string = bastion_subnet.id
output resourceSubnetId string = resource_subnet.id


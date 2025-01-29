param location string = resourceGroup().location

var subscription_id = '8c01f775-0496-43bc-a889-65565e670e05'
var virtualNetworkName = '${subscription_id}-eastus-test-spoke'
var addressSpace = '10.1.0.0/16'

var publicSubnetName = 'public-subnet-eastus-test-spoke'
var publicSubnetPrefix = '10.1.1.0/24'

var privateSubnetName = 'private-subnet-eastus-test-spoke'
var privateSubnetPrefix = '10.1.2.0/24'

resource spoke_vnet 'Microsoft.Network/virtualNetworks@2023-11-01' = {
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

resource private_subnet 'Microsoft.Network/virtualNetworks/subnets@2024-05-01' = {
  parent: spoke_vnet
  name: privateSubnetName
  properties: {
    addressPrefix: privateSubnetPrefix
    privateEndpointNetworkPolicies: 'Disabled'
    defaultOutboundAccess: false
  }
}

resource public_subnet 'Microsoft.Network/virtualNetworks/subnets@2024-05-01' = {
  parent: spoke_vnet
  name: publicSubnetName
  properties: {
    addressPrefix: publicSubnetPrefix
  }
}

output spokeVnetId string = spoke_vnet.id
output spokeVnetName string = spoke_vnet.name
output spokePublicSubnetId string = private_subnet.id
output spokePrivateSubnetId string = public_subnet.id

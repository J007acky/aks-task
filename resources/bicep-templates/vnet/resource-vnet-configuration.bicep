var namingConfig = loadYamlContent('./config-files/naming-config.yml')
var vnetConfig = loadYamlContent('./config-files/vnet-config.yaml')


var virtualNetworkName = '${namingConfig.subscriptionId}-${namingConfig.resourceVnetRegion}-${namingConfig.environment}-resource-vnet'
var addressSpace = vnetConfig.resourceVnetCidr

var publicSubnetName = '${virtualNetworkName}-public-subnet'
var publicSubnetPrefix = vnetConfig.publicSubnetResourceVnetPrefix

var privateSubnetName = '${virtualNetworkName}-private-subnet'
var privateSubnetPrefix = vnetConfig.privateSubnetResourceVnetPrefix
var location = vnetConfig.resourceVnetResourceRegion

resource resourceVnet 'Microsoft.Network/virtualNetworks@2023-11-01' = {
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

resource gatewayRouteTable 'Microsoft.Network/routeTables@2024-05-01' = {
  location: location
  name: 'route-traffic-to-gateway-resource-vnet-subnets'
  properties: {
    routes: [
      {
        name: 'gateway-routes'
        properties: {
          addressPrefix: vnetConfig.sharedVnetCidr
          nextHopType: 'VirtualNetworkGateway'
        }
      }
    ]
  }
}

resource privateSubnet 'Microsoft.Network/virtualNetworks/subnets@2024-05-01' = {
  parent: resourceVnet
  name: privateSubnetName
  properties: {
    addressPrefix: privateSubnetPrefix
    defaultOutboundAccess: false
    routeTable: {
      id: gatewayRouteTable.id
    }
  }
}

resource publicSubnet 'Microsoft.Network/virtualNetworks/subnets@2024-05-01' = {
  parent: resourceVnet
  name: publicSubnetName
  properties: {
    addressPrefix: publicSubnetPrefix
    routeTable: {
      id: gatewayRouteTable.id
    }
  }
}

resource gatewaySubnetResource 'Microsoft.Network/virtualNetworks/subnets@2024-05-01' = {
  parent: resourceVnet
  name: 'GatewaySubnet'
  properties: {
    addressPrefix: vnetConfig.gatewaySubnetResourceVnetPrefix
    defaultOutboundAccess: false
  }
}

output resourceVnetId string = resourceVnet.id
output resourceVnetName string = resourceVnet.name
output resourcePublicSubnetId string = privateSubnet.id
output resourcePrivateSubnetId string = publicSubnet.id

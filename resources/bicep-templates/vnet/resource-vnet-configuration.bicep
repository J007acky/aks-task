var namingConfig = loadYamlContent('../../../config/main-config.yml')
var vnetConfig = loadYamlContent('../../../config/vnet-config.yaml')

var virtualNetworkName = '${namingConfig.SUBSCRIPTION_NAME}-${namingConfig.RESOURCES_REGION}-${namingConfig.ENVIRONMENT}-resource-vnet'
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

resource gatewaySubnetResource 'Microsoft.Network/virtualNetworks/subnets@2024-05-01' = {
  parent: resourceVnet
  name: 'GatewaySubnet'
  properties: {
    addressPrefix: vnetConfig.gatewaySubnetResourceVnetPrefix
    defaultOutboundAccess: false
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
  dependsOn:[
    resourceVnet
  ]
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
  dependsOn:[
    gatewaySubnetResource
  ]
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
  dependsOn:[
    privateSubnet
  ]
}

output resourceVnetId string = resourceVnet.id
output resourceVnetName string = virtualNetworkName
output resourcePublicSubnetId string = privateSubnet.id
output resourcePrivateSubnetId string = publicSubnet.id

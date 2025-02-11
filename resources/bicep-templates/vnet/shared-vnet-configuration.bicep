var vnetConfig = loadYamlContent('../../../config/vnet-config.yaml')
var namingConfig = loadYamlContent('../../../config/main-config.yml')

var location = vnetConfig.sharedVnetResourceRegion

var virtualNetworkName = '${namingConfig.SUBSCRIPTION_NAME}-${namingConfig.SHARED_REGION}-${namingConfig.ENVIRONMENT}-shared-vnet'
var addressSpace = vnetConfig.sharedVnetCidr

var bastionSubnetPrefix = vnetConfig.bastionSubnetSharedVnetPrefix

var publicSubnetName = '${virtualNetworkName}-public-subnet'
var publicSubnetPrefix = vnetConfig.publicSubnetSharedVnetPrefix

var privateSubnetName = '${virtualNetworkName}-private-subnet'
var privateSubnetPrefix = vnetConfig.privateSubnetSharedVnetPrefix

resource sharedVnet 'Microsoft.Network/virtualNetworks@2023-11-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressSpace
      ]
    }
  }
  tags:{
    project: 'aks-task'
    environment: namingConfig.ENVIRONMENT
  }
}

resource gatewayRouteTable 'Microsoft.Network/routeTables@2024-05-01' = {
  location: location
  name: 'route-traffic-to-gateway-subnet-shared-vnet'
  properties: {
    routes: [
      {
        name: 'gateway-routes'
        properties: {
          addressPrefix: vnetConfig.resourceVnetCidr
          nextHopType: 'VirtualNetworkGateway'
        }
      }
    ]
  }
  dependsOn:[
    sharedVnet
  ]
  tags:{
    project: 'aks-task'
    environment: namingConfig.ENVIRONMENT
  }
}

resource bastionSubnet 'Microsoft.Network/virtualNetworks/subnets@2024-05-01' = {
  parent: sharedVnet
  name: 'AzureBastionSubnet'
  properties: {
    addressPrefix: bastionSubnetPrefix
    defaultOutboundAccess: false
  }
}

resource publicResourceSubnet 'Microsoft.Network/virtualNetworks/subnets@2024-05-01' = {
  parent: sharedVnet
  name: publicSubnetName
  properties: {
    addressPrefix: publicSubnetPrefix
    routeTable:{
      id: gatewayRouteTable.id
    }
  }
  dependsOn:[
    bastionSubnet
  ]
}

resource privateResourceSubnet 'Microsoft.Network/virtualNetworks/subnets@2024-05-01' = {
  parent: sharedVnet
  name: privateSubnetName
  properties: {
    addressPrefix: privateSubnetPrefix
    defaultOutboundAccess: false
    routeTable:{
      id: gatewayRouteTable.id
    }
  }
  dependsOn:[
    publicResourceSubnet
  ]
}

resource gatewaySubnetResource 'Microsoft.Network/virtualNetworks/subnets@2024-05-01' = {
  parent: sharedVnet
  name: 'GatewaySubnet'
  properties: {
    addressPrefix: vnetConfig.gatewaySubnetSharedVnetPrefix
    defaultOutboundAccess: false
  }
  dependsOn:[
    privateResourceSubnet
  ]
}

output sharedVnetId string = sharedVnet.id
output sharedVnetName string = sharedVnet.name
output bastionSubnetSharedVnetId string = bastionSubnet.id
output publicResourceSubnetSharedVnet string = publicResourceSubnet.id
output privateResourceSubnetSharedVnet string = privateResourceSubnet.id

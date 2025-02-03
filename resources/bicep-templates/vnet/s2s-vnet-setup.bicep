
param sharedVnetRg string
param resourceVnetRg string

param sharedVnetName string
param resourceVnetName string

param sharedKey string


var vnetConfig = loadYamlContent('./config-files/vnet-config.yaml')
var namingConfig = loadYamlContent('./config-files/naming-config.yml')


var sharedVnetVngName =  '${namingConfig.subscriptionId}-${namingConfig.sharedVnetRegion}-${namingConfig.environment}-shared-vng'
var resourceVnetVngName = '${namingConfig.subscriptionId}-${namingConfig.sharedVnetRegion}-${namingConfig.environment}-resource-vng'


var sharedVnetLngName =  '${namingConfig.subscriptionId}-${namingConfig.sharedVnetRegion}-${namingConfig.environment}-shared-lng'
var resourceVnetLngName = '${namingConfig.subscriptionId}-${namingConfig.sharedVnetRegion}-${namingConfig.environment}-resource-lng'


var sharedVnetVngPublicIpName = '${namingConfig.subscriptionId}-${namingConfig.sharedVnetRegion}-${namingConfig.environment}-shared-public-ip'
var resourceVnetVngPublicIpName = '${namingConfig.subscriptionId}-${namingConfig.sharedVnetRegion}-${namingConfig.environment}-resource-public-ip'




module sharedVnetS2SResourceSetup './modules/site-to-site-ipsec-gateway-configuration.bicep'={
    scope: resourceGroup(sharedVnetRg)
    name: 'shared-vnet-s2s-setup'
    params:{
      virtualNetworkGatewayName: sharedVnetVngName
      localNetworkGatewayName: sharedVnetLngName
      locationForVNG: vnetConfig.sharedVnetResourceRegion
      locationForLNG: vnetConfig.resourceVnetResourceRegion
      parentVnetName: sharedVnetName
      parentVnetCidr: vnetConfig.sharedVnetCidr
      publicIpName: sharedVnetVngPublicIpName
    }
}

module resourceVnetS2SResourceSetup './modules/site-to-site-ipsec-gateway-configuration.bicep'={
  scope:resourceGroup(resourceVnetRg)
  name: 'resource-vnet-s2s-setup'
  params:{
    virtualNetworkGatewayName: resourceVnetVngName
    localNetworkGatewayName: resourceVnetLngName
    locationForVNG: vnetConfig.resourceVnetResourceRegion
    locationForLNG: vnetConfig.sharedVnetResourceRegion
    parentVnetName: resourceVnetName
    parentVnetCidr: vnetConfig.resourceVnetCidr
    publicIpName: resourceVnetVngPublicIpName
  }
}


module sharedVnetVngToResourceVnetLng './modules/connection-between-lng-and-vng.bicep'={
  name: 'connection-shared-vnet-vng-and-resource-vnet-lng'
  scope: resourceGroup(sharedVnetRg)
  params: {
    sharedKey: sharedKey
    virtualNetworkGatewayID: sharedVnetS2SResourceSetup.outputs.vnetVngId
    localNetworkGatewayId: resourceVnetS2SResourceSetup.outputs.vnetLngId
    locationForConnection: vnetConfig.sharedVnetResourceRegion
    connectionName: 'connection-shared-vnet-vng-and-resource-vnet-lng'
  }
}

module resourceVnetVngToSharedVnetLng './modules/connection-between-lng-and-vng.bicep'={
  name: 'connection-resource-vnet-vng-and-shared-vnet-lng'
  scope: resourceGroup(resourceVnetRg)
  params: {
    sharedKey: sharedKey
    virtualNetworkGatewayID: resourceVnetS2SResourceSetup.outputs.vnetVngId
    localNetworkGatewayId: sharedVnetS2SResourceSetup.outputs.vnetLngId
    locationForConnection: vnetConfig.resourceVnetResourceRegion
    connectionName: 'connection-resource-vnet-vng-and-shared-vnet-lng'
  }
}


output sharedVngName string = sharedVnetVngName
output resourceVngName string = resourceVnetVngName

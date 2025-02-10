var vnetConfig = loadYamlContent('../../../config/vnet-config.yaml')
var namingConfig = loadYamlContent('../../../config/main-config.yml')

@description('name of resource group - shared vnet')
param sharedVnetRg string

@description('name of vnet - shared vnet')
param sharedVnetName string

@description('name of resource group - resource vnet')
param resourceVnetRg string

@description('name of vnet - resource vnet')
param resourceVnetName string

@description('Shared key for creating s2s connection')
param sharedKey string

var sharedVnetVngName =  '${namingConfig.SUBSCRIPTION_NAME}-${namingConfig.SHARED_REGION}-${namingConfig.ENVIRONMENT}-shared-vng'
var resourceVnetVngName = '${namingConfig.SUBSCRIPTION_NAME}-${namingConfig.RESOURCES_REGION}-${namingConfig.ENVIRONMENT}-resource-vng'

var sharedVnetLngName =  '${namingConfig.SUBSCRIPTION_NAME}-${namingConfig.SHARED_REGION}-${namingConfig.ENVIRONMENT}-shared-lng'
var resourceVnetLngName = '${namingConfig.SUBSCRIPTION_NAME}-${namingConfig.RESOURCES_REGION}-${namingConfig.ENVIRONMENT}-resource-lng'

var sharedVnetVngPublicIpName = '${namingConfig.SUBSCRIPTION_NAME}-${namingConfig.SHARED_REGION}-${namingConfig.ENVIRONMENT}-shared-public-ip'
var resourceVnetVngPublicIpName = '${namingConfig.SUBSCRIPTION_NAME}-${namingConfig.RESOURCES_REGION}-${namingConfig.ENVIRONMENT}-resource-public-ip'

module sharedVnetS2SResourceSetup './modules/site-to-site-ipsec-gateway-configuration.bicep'={
    scope: resourceGroup(sharedVnetRg)
    name: '${namingConfig.ENVIRONMENT}-shared-vnet-s2s-setup'
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
  name: '${namingConfig.ENVIRONMENT}-resource-vnet-s2s-setup'
  params:{
    virtualNetworkGatewayName: resourceVnetVngName
    localNetworkGatewayName: resourceVnetLngName
    locationForVNG: vnetConfig.resourceVnetResourceRegion
    locationForLNG: vnetConfig.sharedVnetResourceRegion
    parentVnetName: resourceVnetName
    parentVnetCidr: vnetConfig.resourceVnetCidr
    publicIpName: resourceVnetVngPublicIpName
  }
  dependsOn:[
    sharedVnetS2SResourceSetup
  ]
}

module sharedVnetVngToResourceVnetLng './modules/connection-between-lng-and-vng.bicep'={
  name: '${namingConfig.ENVIRONMENT}-connection-shared-vnet-vng-and-resource-vnet-lng'
  scope: resourceGroup(sharedVnetRg)
  params: {
    sharedKey: sharedKey
    virtualNetworkGatewayID: sharedVnetS2SResourceSetup.outputs.vnetVngId
    localNetworkGatewayId: resourceVnetS2SResourceSetup.outputs.vnetLngId
    locationForConnection: vnetConfig.sharedVnetResourceRegion
    connectionName: '${namingConfig.ENVIRONMENT}-connection-shared-vnet-vng-and-resource-vnet-lng'
  }
}

module resourceVnetVngToSharedVnetLng './modules/connection-between-lng-and-vng.bicep'={
  name: '${namingConfig.ENVIRONMENT}-connection-resource-vnet-vng-and-shared-vnet-lng'
  scope: resourceGroup(resourceVnetRg)
  params: {
    sharedKey: sharedKey
    virtualNetworkGatewayID: resourceVnetS2SResourceSetup.outputs.vnetVngId
    localNetworkGatewayId: sharedVnetS2SResourceSetup.outputs.vnetLngId
    locationForConnection: vnetConfig.resourceVnetResourceRegion
    connectionName: '${namingConfig.ENVIRONMENT}-connection-resource-vnet-vng-and-shared-vnet-lng'
  }
  dependsOn:[
    sharedVnetVngToResourceVnetLng
  ]
}

output sharedVngName string = sharedVnetVngName
output resourceVngName string = resourceVnetVngName

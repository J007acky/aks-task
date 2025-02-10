@description('The resource group of shared vnet')
param sharedVnetRgName string

@description('The resource group of resource vnet')
param resourceVnetRgName string

@description('The name of your shared Vnet')
param sharedVnetName string

@description('The name of your resource vnet')
param resourceVnetName string

@description('The ID of shared Vnet')
param sharedVnetId string

@description('The id of resource Vnet')
param resourceVnetId string

module sharedVnetToResourceVnetPeering './modules/vnet-peering.bicep'={
  scope:resourceGroup(sharedVnetRgName)
  name: 'hub-to-spoke-peering'
  params:{
    parentVnetName: sharedVnetName
    remoteVnetId: resourceVnetId
  }
}


module resourceVnetToSharedVnetPeering './modules/vnet-peering.bicep'={
  scope:resourceGroup(resourceVnetRgName)
  name: 'spoke-to-hub-peering'
  params:{
    parentVnetName: resourceVnetName
    remoteVnetId: sharedVnetId
  }
}

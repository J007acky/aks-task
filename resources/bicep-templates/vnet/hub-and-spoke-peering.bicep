param hubRgName string
param spokeRgName string
param hubVnetName string
param spokeVnetName string
param hubVnetId string
param spokeVnetId string

module hub_to_spoke_peering './modules/vnet-peering.bicep'={
  scope:resourceGroup(hubRgName)
  name: 'hub-to-spoke-peering'
  params:{
    parentVnetName: hubVnetName
    remoteVnetId: spokeVnetId
  }
}


module spoke_to_hub_peering './modules/vnet-peering.bicep'={
  scope:resourceGroup(spokeRgName)
  name: 'spoke-to-hub-peering'
  params:{
    parentVnetName: spokeVnetName
    remoteVnetId: hubVnetId
  }
}

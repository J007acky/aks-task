param parentVnetName string
param remoteVnetId string

resource vnet_1 'Microsoft.Network/virtualNetworks@2022-09-01' existing = {
  name: parentVnetName
}

resource hub_to_spoke_peering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2024-05-01' = {
  parent: vnet_1
  name: 'spoke-to-hub-peering'
  properties:{
    remoteVirtualNetwork:{
      id:remoteVnetId
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
  }
}



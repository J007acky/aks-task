param parentVnetName string
param remoteVnetId string

resource parentVnet 'Microsoft.Network/virtualNetworks@2022-09-01' existing = {
  name: parentVnetName
}

resource parentVnetToRemoteVnetPeering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2024-05-01' = {
  parent: parentVnet
  name: 'spoke-to-hub-peering'
  properties:{
    remoteVirtualNetwork:{
      id:remoteVnetId
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
  }
}



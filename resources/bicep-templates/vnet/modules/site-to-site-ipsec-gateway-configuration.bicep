param locationForVNG string
param virtualNetworkGatewayName string
param localNetworkGatewayName string
param publicIpName string
param gatewaySubnetPrefix string
param parentVnetName string
param locationForLNG string
param parentVnetCidr string

resource vnetToBeConnected 'Microsoft.Network/virtualNetworks@2022-09-01' existing = {
  name: parentVnetName
}

resource gatewaySubnetResource 'Microsoft.Network/virtualNetworks/subnets@2024-05-01' = {
  parent: vnetToBeConnected
  name: 'GatewaySubnet'
  properties: {
    addressPrefix: gatewaySubnetPrefix
    defaultOutboundAccess: false
  }
}

resource publicIpForVirtualNetworkGateway 'Microsoft.Network/publicIPAddresses@2022-01-01' = {
  name: publicIpName
  location: locationForVNG
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }

}

resource virtualNetworkGatewayResource 'Microsoft.Network/virtualNetworkGateways@2024-05-01' = {
  location: locationForVNG
  name: virtualNetworkGatewayName
  properties: {
    gatewayType: 'Vpn'
    ipConfigurations: [
      {
        name: 'primary-public-ip-address'
        properties: {
          publicIPAddress: {
            id: publicIpForVirtualNetworkGateway.id
          }
          subnet: {
            id: gatewaySubnetResource.id
          }
        }
      }
    ]
    sku: {
      name: 'VpnGw2'
      tier: 'VpnGw2'
    }
    vpnGatewayGeneration: 'Generation2'
    vpnType: 'RouteBased'
  }
}


resource localNetworkGatewayResource 'Microsoft.Network/localNetworkGateways@2024-05-01' = {
  location: locationForLNG
  name: localNetworkGatewayName
  properties: {
    gatewayIpAddress: publicIpForVirtualNetworkGateway.properties.ipAddress
    localNetworkAddressSpace: {
      addressPrefixes: [
        parentVnetCidr
      ]
    }
  }
}


output vnetVngId string = virtualNetworkGatewayResource.id
output vnetLngId string = localNetworkGatewayResource.id

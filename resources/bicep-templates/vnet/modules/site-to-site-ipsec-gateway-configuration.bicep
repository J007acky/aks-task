@description('Location of the VNG - same as the location of parent vnet')
param locationForVNG string

@description('Name of your virtual network gateway')
param virtualNetworkGatewayName string

@description('Name of the LNG to represent this vnet')
param localNetworkGatewayName string

@description('Name for public ip which is associated to VNG')
param publicIpName string

@description('Name of your parent ')
param parentVnetName string

@description('Location for LNG - will be same as the location of another vnet')
param locationForLNG string

@description('CIDR of the parent Vnet')
param parentVnetCidr string

@description('Current Working Environment')
param environment string

resource publicIpForVirtualNetworkGateway 'Microsoft.Network/publicIPAddresses@2022-01-01' = {
  name: publicIpName
  location: locationForVNG
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
  tags: {
    project: 'aks-task'
    environment: environment
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
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', parentVnetName, 'GatewaySubnet')
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
  tags:{
    project: 'aks-task'
    environment: environment
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
  tags:{
    project: 'aks-task'
    environment: environment
  }
}

output vnetVngId string = virtualNetworkGatewayResource.id
output vnetLngId string = localNetworkGatewayResource.id

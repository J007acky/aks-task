@secure()
@description('The shared key for LNG and VNG connection')
param sharedKey string

@description('Location of your VNG and LNG - ensure that both should be in same vnet')
param locationForConnection string

@description('Name of connection between vng and lng')
param connectionName string

@description('ID of LNG - will represent other vnet')
param localNetworkGatewayId string

@description('ID of VNG - vpn gateway of the main vnet')
param virtualNetworkGatewayID string

@description('Current Environment of the connection')
param environment string

resource s2sConnectionBetweenLngAndVng 'Microsoft.Network/connections@2024-05-01' = {
  location: locationForConnection
  name: connectionName
  properties: {
    connectionMode: 'Default'
    connectionProtocol: 'IKEv2'
    connectionType: 'IPsec'
    dpdTimeoutSeconds: 45


    localNetworkGateway2: {
      id: localNetworkGatewayId
      properties:{}
    }

    sharedKey: sharedKey

    virtualNetworkGateway1: {
      id: virtualNetworkGatewayID
      properties:{}
    }
  }
  tags:{
    project: 'aks-task'
    environment: environment
  }
}

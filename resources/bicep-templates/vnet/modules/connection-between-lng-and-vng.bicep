param sharedKey string

param locationForConnection string
param connectionName string
param localNetworkGatewayId string
param virtualNetworkGatewayID string

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
}

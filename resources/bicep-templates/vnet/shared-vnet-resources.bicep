
var vnetConfig = loadYamlContent('./config-files/vnet-config.yaml')
var namingConfig = loadYamlContent('./config-files/naming-config.yml')


var publicIpName  = '${namingConfig.subscriptionId}-${namingConfig.sharedVnetRegion}-${namingConfig.environment}-bastion-public-ip'
var bastionHostName  = '${namingConfig.subscriptionId}-${namingConfig.sharedVnetRegion}-${namingConfig.environment}-bastion-host'
param bastionSubnetId string

resource publicIpAddressForBastion 'Microsoft.Network/publicIPAddresses@2022-01-01' = {
  name: publicIpName
  location: vnetConfig.sharedVnetResourceRegion
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

resource bastionHost 'Microsoft.Network/bastionHosts@2022-01-01' = {
  name: bastionHostName
  location: vnetConfig.sharedVnetResourceRegion
  properties: {
    ipConfigurations: [
      {
        name: 'bastion-subnet'
        properties: {
          subnet: {
            id: bastionSubnetId
          }
          publicIPAddress: {
            id: publicIpAddressForBastion.id
          }
        }
      }
    ]
  }
}

output bastionId string = bastionHost.id

var vnetConfig = loadYamlContent('../../../config/vnet-config.yaml')
var namingConfig = loadYamlContent('../../../config/main-config.yml')

@description('complete subnet id for bastion host in shared vnet')
param bastionSubnetId string

var publicIpName  = '${namingConfig.SUBSCRIPTION_NAME}-${namingConfig.SHARED_REGION}-${namingConfig.ENVIRONMENT}-bastion-public-ip'
var bastionHostName  = '${namingConfig.SUBSCRIPTION_NAME}-${namingConfig.SHARED_REGION}-${namingConfig.ENVIRONMENT}-bastion-host'

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
    enableShareableLink: true
    enableTunneling: true
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
  sku:{
    name:'Standard'
  }
}

output bastionId string = bastionHost.id

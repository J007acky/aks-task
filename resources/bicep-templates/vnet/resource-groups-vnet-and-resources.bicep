targetScope = 'subscription'

var rgconfig = loadYamlContent('./config-files/naming-config.yml')

var sharedVnetRgName  = '${rgconfig.subscriptionId}-${rgconfig.sharedVnetRegion}-${rgconfig.environment}-shared-rg'
var resourceVnetRgName = '${rgconfig.subscriptionId}-${rgconfig.resourceVnetRegion}-${rgconfig.environment}-resource-rg'

resource sharedVnetRg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: sharedVnetRgName
  location: rgconfig.sharedVnetRegion
}


resource resourceVnetRg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceVnetRgName
  location: rgconfig.resourceVnetRegion
}


output sharedVnetRgName string = sharedVnetRg.name
output resourceVnetRg string = resourceVnetRg.name

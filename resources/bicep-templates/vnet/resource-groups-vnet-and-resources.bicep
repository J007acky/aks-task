targetScope = 'subscription'

var rgconfig = loadYamlContent('../../../config/main-config.yml')

var sharedVnetRgName  = '${rgconfig.SUBSCRIPTION_NAME}-${rgconfig.SHARED_REGION}-${rgconfig.ENVIRONMENT}-shared-rg'
var resourceVnetRgName = '${rgconfig.SUBSCRIPTION_NAME}-${rgconfig.RESOURCES_REGION}-${rgconfig.ENVIRONMENT}-resource-rg'

resource sharedVnetRg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: sharedVnetRgName
  location: rgconfig.SHARED_REGION
}

resource resourceVnetRg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceVnetRgName
  location: rgconfig.RESOURCES_REGION
}

output sharedVnetRgName string = sharedVnetRg.name
output resourceVnetRg string = resourceVnetRg.name

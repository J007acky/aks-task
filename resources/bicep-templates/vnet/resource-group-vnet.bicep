targetScope = 'subscription'

var rgconfig = loadYamlContent('./config-files/rg-config.yml')

var hub_rg_name  = '${rgconfig.subscriptionId}-${rgconfig.hubVnetResourceRegion}-${rgconfig.environment}-hub-rg'
var spoke_rg_name = '${rgconfig.subscriptionId}-${rgconfig.spokeVnetResourceRegion}-${rgconfig.environment}-spoke-rg'

resource hub_vnet_rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: hub_rg_name
  location: rgconfig.hubVnetResourceRegion
}


resource spoke_vnet_rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: spoke_rg_name
  location: rgconfig.spokeVnetResourceRegion
}


output hub_rg_name string = hub_vnet_rg.name
output spoke_rg_name string = spoke_vnet_rg.name

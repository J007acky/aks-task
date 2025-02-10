using 'resource-group.bicep'

var configFile = loadYamlContent('../../../config/main-config.yml')

// Prefix for the resource group names
param rgName = '${configFile.SUBSCRIPTION_NAME}-${configFile.RESOURCES_REGION}-${configFile.ENVIRONMENT}'

// Location for the resource group
param rgLocation = configFile.RESOURCES_REGION

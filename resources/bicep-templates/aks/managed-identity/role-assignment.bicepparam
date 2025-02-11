using 'role-assignment.bicep'

var configFile = loadYamlContent('../../../../config/main-config.yml')

var aksConfigFile = loadYamlContent('../../../../config/aks-config.yml')

// Resource Group name prefix
param rgNamePrefix = '${configFile.SUBSCRIPTION_NAME}-${configFile.RESOURCES_REGION}-${configFile.ENVIRONMENT}'

param roles = aksConfigFile.ROLE_NAMES

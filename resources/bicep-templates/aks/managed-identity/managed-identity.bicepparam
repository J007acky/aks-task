using 'managed-identity.bicep'

var configFile = loadYamlContent('../../../../config/main-config.yml')

param aksManagedIdentityName = '${configFile.SUBSCRIPTION_NAME}-${configFile.RESOURCES_REGION}-${configFile.ENVIRONMENT}-identity-aks-managed-identity'

param kubeletManagedIdentityName = '${configFile.SUBSCRIPTION_NAME}-${configFile.RESOURCES_REGION}-${configFile.ENVIRONMENT}-identity-kubelet-managed-identity'

param location = configFile.RESOURCES_REGION

param environment = configFile.ENVIRONMENT

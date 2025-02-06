using 'managed-identity.bicep'

var configFile = loadYamlContent('../config.yml')

param aksManagedIdentityName = '${configFile.subscription}-${configFile.location}-${configFile.environment}-identity-aks-managed-identity'

param kubeletManagedIdentityName = '${configFile.subscription}-${configFile.location}-${configFile.environment}-identity-kubelet-managed-identity'

param location = configFile.location

param vnetResourceGroup = '${configFile.subscription}-${configFile.location}-${configFile.environment}-resource-rg'

param vNetName = '${configFile.subscription}-${configFile.location}-${configFile.environment}-resource-vnet'

using 'role-assignment.bicep'

var configFile = loadYamlContent('../config.yml')

// Resource Group name prefix
param rgNamePrefix = '${configFile.subscription}-${configFile.location}-${configFile.environment}'

using 'test-vm.bicep'

var configFile = loadYamlContent('../../../../config/main-config.yml')

// Name of the Virtual Machine
param rgNamePrefix = '${configFile.SUBSCRIPTION_NAME}-${configFile.SHARED_REGION}-${configFile.ENVIRONMENT}'

// Location of the Virtual Machine
param vmLocation = configFile.SHARED_REGION

// Environment of the resources to be deployed in
param environment = configFile.ENVIRONMENT

// Initializing secured parameters with empty string
param vmUsername = 'Rahul'
param vmPassword = ''
param sshKeyVM = ''

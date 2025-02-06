using 'test-vm.bicep'

var configFile = loadYamlContent('../config.yml')

// Name of the Virtual Machine
param rgNamePrefix = '${configFile.subscription}-${configFile.locationShared}-${configFile.environment}'

// Location of the Virtual Machine
param vmLocation = configFile.locationShared

// Subnet ID where the Virtual Machine will be deployed
// param subnetId = '/subscriptions/82103d68-e454-42a4-acbf-1b71e64bca29/resourceGroups/Azure-For-Students-westus-dev-resource-rg/providers/Microsoft.Network/virtualNetworks/Azure-For-Students-westus-dev-resource-vnet/subnets/Azure-For-Students-westus-dev-resource-vnet-private-subnet'

// Initializing secured parameters with empty string
param vmUsername = 'Rahul'
param vmPassword = ''
param sshKeyVM = ''

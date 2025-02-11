using 'aks-cluster.bicep'

var configFile = loadYamlContent('../../../../config/main-config.yml')
var aksConfigFile = loadYamlContent('../../../../config/aks-config.yml')

// Environment of the resources to be deployed in
param environment = configFile.ENVIRONMENT

// Location where the AKS cluster will be created
param aksLocation = configFile.RESOURCES_REGION

// Resource Group name prefix
param rgNamePrefix = '${configFile.SUBSCRIPTION_NAME}-${configFile.RESOURCES_REGION}-${configFile.ENVIRONMENT}'

// DNS prefix for the AKS cluster
param dnsPrefix = aksConfigFile.DNS_PREFIX

// SSH RSA public key string
param sshRSAPublicKey = 'SSH_KEY'

// Number of nodes for the cluster
param agentCount = aksConfigFile.AGENT_COUNT

// Size of the VM for agent nodes
param agentVMSize = aksConfigFile.AGENT_VM_SIZE

// User name for the Linux VM
param linuxAdminUsername = aksConfigFile.LNX_ADMIN_USERNAME

// serviceCidr is the IP address range for the Kubernetes service address range
param serviceCidr = aksConfigFile.SVC_CIDR

// dnsServiceIP is the IP address within the Kubernetes service address range that will be used by cluster service discovery (kube-dns)
param dnsServiceIP = aksConfigFile.DNS_SVC_IP

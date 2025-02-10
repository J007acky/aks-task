@description('Resource group name prefix')
param rgNamePrefix string


@description('The location of the AKS Cluster resource.')
param aksLocation string

@description('DNS prefix for FQDN.')
param dnsPrefix string

@description('The number of nodes for the cluster.')
@minValue(1)
@maxValue(10)
param agentCount int

@description('The size of the Virtual Machine for agent nodes.')
param agentVMSize string

@description('User name for the Linux Virtual Machines.')
param linuxAdminUsername string

@description('Configure all linux machines with the SSH RSA public key string.')
param sshRSAPublicKey string

@description('CIDR range for the Kubernetes service to allocate IPs.')
param serviceCidr string

@description('IP address for the Kubernetes DNS service.')
param dnsServiceIP string

var clusterName = '${rgNamePrefix}-aks'

var vnetSubnetId = resourceId('${rgNamePrefix}-resource-rg', 'Microsoft.Network/virtualNetworks/subnets', '${rgNamePrefix}-resource-vnet', '${rgNamePrefix}-resource-vnet-private-subnet')

var aksManagedIdentityId = '${rgNamePrefix}-identity-aks-managed-identity'

var kubeletManagedIdentityId = '${rgNamePrefix}-identity-kubelet-managed-identity'

resource aksManagedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' existing = {
  scope: resourceGroup('${rgNamePrefix}-aks-rg')
  name: aksManagedIdentityId
}

resource kubeletManagedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' existing = {
  scope: resourceGroup('${rgNamePrefix}-aks-rg')
  name: kubeletManagedIdentityId
}


resource aksPublicIP 'Microsoft.Network/publicIPAddresses@2024-05-01' = {
  name: '${rgNamePrefix}-aks-ip'
  location: resourceGroup().location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
  }
}


resource aks 'Microsoft.ContainerService/managedClusters@2024-02-01' = {
  name: clusterName
  location: aksLocation
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${aksManagedIdentity.id}':{}
    }
  }
  properties: {
    
    identityProfile:{
      kubeletidentity:{
        clientId: kubeletManagedIdentity.properties.clientId
        objectId: kubeletManagedIdentity.properties.principalId
        resourceId: kubeletManagedIdentity.id
      }
    }
    agentPoolProfiles: [
      {
        name: 'deadpool'
        count: agentCount
        vmSize: agentVMSize
        osType: 'Linux'
        mode: 'System'
        vnetSubnetID: vnetSubnetId
        type: 'VirtualMachineScaleSets'
        enableAutoScaling: true
        minCount: 1
        maxCount: 3
      }
    ]
    aadProfile: {
      managed: true
      enableAzureRBAC: true
    }
    networkProfile: {
      networkPlugin: 'azure'
      loadBalancerSku: 'standard'
      serviceCidr: serviceCidr
      dnsServiceIP: dnsServiceIP
      loadBalancerProfile: {
        outboundIPs: {
          publicIPs: [
            aksPublicIP
          ]
        }
      }
    }
    apiServerAccessProfile: {
      enablePrivateCluster: true
    }
    linuxProfile: {
      adminUsername: linuxAdminUsername
      ssh: {
        publicKeys: [
          {
            keyData: sshRSAPublicKey
          }
        ]
      }
    }
    
    dnsPrefix: dnsPrefix
  }
}

output privateControlPlaneFQDN string = aks.properties.privateFQDN
output resourceId string = aks.id

param clusterName string = 'dpp-aks'
param location string = resourceGroup().location
param nodeCount int = 1
param nodeVmSize string = 'Standard_B2s_v2'
param identityName string = 'dpp-identity'

resource identity 'Microsoft.ManagedIdentity/userAssignedIdentities@2024-11-30' existing = {
  name: identityName
}

resource aks 'Microsoft.ContainerService/managedClusters@2026-01-01' = {
  name: clusterName
  location: location
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${identity.id}': {}
    }
  }
  properties: {
    dnsPrefix: clusterName
    agentPoolProfiles: [
      {
        name: 'nodepool1'
        count: nodeCount
        vmSize: nodeVmSize
        mode: 'System'
        osDiskSizeGB: 64
      }
    ]
    networkProfile: {
      networkPlugin: 'kubenet'
      loadBalancerSku: 'standard'
    }
  }
}

output controlPlaneFQDN string = aks.properties.fqdn
output clusterName string = aks.name

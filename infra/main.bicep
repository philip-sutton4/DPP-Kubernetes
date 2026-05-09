param clusterName string = 'dpp-aks'
param location string = resourceGroup().location
param nodeCount int = 1
param nodeVmSize string = 'Standard_B2s_v2'

resource aks 'Microsoft.ContainerService/managedClusters@2026-01-01' = {
  name: clusterName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    dnsPrefix: clusterName
    agentPoolProfiles: [
      {
        name: 'nodepool1'
        count: nodeCount
        vmSize: nodeVmSize
        mode: 'System'
        osDiskSizeGB: 30
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

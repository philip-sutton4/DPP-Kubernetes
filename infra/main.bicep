param clusterName string = 'dpp-aks'
param location string = resourceGroup().location
param nodeCount int = 1
param nodeVmSize string = 'Standard_B2s_v2'
param identityName string = 'dpp-identity'

// Create the identity as part of the same deployment
resource identity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: identityName
  location: location
}

resource aks 'Microsoft.ContainerService/managedClusters@2023-01-01' = {
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
  dependsOn: [
    identity
  ]
}

output controlPlaneFQDN string = aks.properties.fqdn
output clusterName string = aks.name
output identityClientId string = identity.properties.clientId
output identityPrincipalId string = identity.properties.principalId
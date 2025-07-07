
param location string = resourceGroup().location
param environmentName string
@secure()
param storageAccountName string
@secure()
param containerRegistryName string
param managedIdentityName string
param containerAppName string = 'update-rag-app'
param acrImageTag string

@description('Cron schedule for weekly execution in CRON format')
param cronSchedule string = '0 3 * * 1' // Every Monday at 3 AM UTC

resource containerApp 'Microsoft.App/containerApps@2023-05-01' = {
  name: containerAppName
  location: location
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${resourceId('Microsoft.ManagedIdentity/userAssignedIdentities', managedIdentityName)}': {}
    }
  }
  properties: {
    managedEnvironmentId: resourceId('Microsoft.App/managedEnvironments', environmentName)
    configuration: {
      ingress: {
        external: false
        targetPort: 80
      }
      secrets: [
        {
          name: 'storageAccountName'
          value: storageAccountName
        }
        {
          name: 'containerRegistryName'
          value: containerRegistryName
        }
      ]
      registries: [
        {
          server: '${containerRegistryName}.azurecr.io'
          identity: resourceId('Microsoft.ManagedIdentity/userAssignedIdentities', managedIdentityName)
        }
      ]
    }
    template: {
      containers: [
        {
          name: containerAppName
          image: '${containerRegistryName}.azurecr.io/${containerAppName}:${acrImageTag}'
          resources: {
            cpu: 1
            memory: '1Gi'
          }
          env: [
            {
              name: 'AZURE_STORAGE_ACCOUNT'
              value: storageAccountName
            }
            {
              name: 'AZURE_CLIENT_ID'
              value: reference(resourceId('Microsoft.ManagedIdentity/userAssignedIdentities', managedIdentityName), '2023-01-31').clientId
            }
            {
              name: 'ENV'
              value: 'prod' // Replace with your Key Vault secret URI
            }
          ]

        }
      ]
      //restartPolicy: 'OnFailure'

    }



    
  }
}

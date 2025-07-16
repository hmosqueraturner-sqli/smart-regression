param appName string = 'cron-update-rag'
param containerAppsEnvName string
param location string = resourceGroup().location
param acrName string
param userAssignedIdentityName string

resource containerEnv 'Microsoft.App/managedEnvironments@2023-05-01' existing = {
  name: containerAppsEnvName
}

resource acr 'Microsoft.ContainerRegistry/registries@2023-01-01-preview' existing = {
  name: acrName
}

resource identity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' existing = {
  name: userAssignedIdentityName
}

resource cronJob 'Microsoft.App/jobs@2023-05-01' = {
  name: appName
  location: location
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${identity.id}': {}
    }
  }
  properties: {
    environmentId: containerEnv.id
    configuration: {
      registries: [
        {
          server: '${acr.name}.azurecr.io'
          identity: identity.id
        }
      ]
      replicaTimeout: 1800 // Optional: timeout in seconds
      triggerType: 'Schedule'
      scheduleTriggerConfig: {
        cronExpression: '0 5 * * 0' // Every Sunday at 5am UTC
      }
    }
    template: {
      containers: [
        {
          name: appName
          image: '${acr.name}.azurecr.io/${appName}:latest'
          resources: {
            cpu: 1
            memory: '1.0Gi'
          }
          env: [
            {
              name: 'AZURE_OPENAI_ENDPOINT'
              secretRef: 'openai-endpoint'
            }
            {
              name: 'AZURE_OPENAI_KEY'
              secretRef: 'openai-key'
            }
            {
              name: 'JIRA_API_TOKEN'
              secretRef: 'jira-token'
            }
            {
              name: 'JIRA_BASE_URL'
              secretRef: 'jira-url'
            }
            {
              name: 'JIRA_USER_EMAIL'
              secretRef: 'jira-user'
            }
          ]
        }
      ]
      // You can set parallelism and retryPolicy if needed
    }
  }
}

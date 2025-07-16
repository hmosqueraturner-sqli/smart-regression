param appName string = 'front-react'
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

resource containerApp 'Microsoft.App/containerApps@2023-05-01' = {
  name: appName
  location: location
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${identity.id}': {}
    }
  }
  properties: {
    managedEnvironmentId: containerEnv.id
    configuration: {
      registries: [
        {
          server: '${acr.name}.azurecr.io'
          identity: identity.id
        }
      ]
      ingress: {
        external: true
        targetPort: 80
        transport: 'auto'
        allowInsecure: false
      }
      activeRevisionsMode: 'Single'
    }
    template: {
      containers: [
        {
          name: appName
          image: '${acr.name}.azurecr.io/${appName}:latest'
          resources: {
            cpu: 1
            memory: '0.5Gi'
          }
          env: [
            {
              name: 'REACT_APP_API_EVALUATE_URL'
              secretRef: 'api-evaluate-url'
            }
            {
              name: 'REACT_APP_API_CREATE_URL'
              secretRef: 'api-create-url'
            }
            {
              name: 'REACT_APP_ENVIRONMENT'
              value: 'production'
            }
          ]
        }
      ]
      scale: {
        minReplicas: 0
        maxReplicas: 1
      }
    }
  }
}

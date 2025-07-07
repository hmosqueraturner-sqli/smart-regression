@description('Container Apps Environment name')
param containerAppEnvName string

@description('Secret name to create')
param secretName string

@description('Secret value to store')
@secure()
param secretValue string

resource containerEnv 'Microsoft.App/managedEnvironments@2023-05-01' existing = {
  name: containerAppEnvName
}

resource secret 'Microsoft.App/managedEnvironments/secrets@2023-05-01' = {
  name: secretName
  parent: containerEnv
  properties: {
    value: secretValue
  }
}

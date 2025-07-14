@description('Nombre del entorno de Azure Container Apps compartido')
param containerAppEnvName string

@description('Ubicación del entorno')
param location string = resourceGroup().location

@description('Secretos requeridos para la aplicación')
param secrets object = {
  'openai-endpoint': '<REEMPLAZAR>'
  'openai-key': '<REEMPLAZAR>'
  'jira-token': '<REEMPLAZAR>'
  'jira-url': '<REEMPLAZAR>'
  'jira-user': '<REEMPLAZAR>'
  'api-evaluate-url': '<REEMPLAZAR>'
  'api-create-url': '<REEMPLAZAR>'
}

resource containerEnv 'Microsoft.App/managedEnvironments@2023-05-01' existing = {
  name: containerAppEnvName
}

@batchSize(1)
module secretsModule 'secrets.bicep' = [
  for secretName in union([], objectKeys(secrets)): {
    name: 'secret-${secretName}'
    params: {
      containerAppEnvName: containerAppEnvName
      secretName: secretName
      secretValue: secrets[secretName]
    }
  }
]

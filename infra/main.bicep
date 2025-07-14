@description('Container Apps Environment name')
param containerAppsEnvName string
@description('Storage Account Name')
param storageAccountName string
@description('blobContainerName name')
param blobContainerName string
@description('cosmosDbEndpoint name')
param cosmosDbEndpoint string
@description('cosmosDbDatabase name')
param cosmosDbDatabase string
@description('azureSearchEndpoint name')
param azureSearchEndpoint string
@description('azureSearchIndex name')
param azureSearchIndex string
@description('openAiEndpoint name')
param openAiEndpoint string
@description('openAiKey name')
param openAiKey string
@description('jiraUrl ')
param jiraUrl string
@description('jiraToken')
param jiraToken string
@description('jiraUser')
param jiraUser string
@description('reactAppApiUrl')
param reactAppApiUrl string
@description('React App Environment name')
param reactAppEnv string
@description('api-Evaluate Url')
param apiEvaluateUrl string
@description('api-Create Url')
param apiCreateUrl string
@description('Managed Identity Name')
param userAssignedIdentityName string
@description('Azure Container Registry Name')
param acrName string

@description('Location for the resources')
param location string = resourceGroup().location

@description('Azure Container Registry')
resource acr 'Microsoft.ContainerRegistry/registries@2023-01-01-preview' = {
  name: acrName
  location: location
  sku: {
    name: 'Basic'
  }
  properties: {
    adminUserEnabled: false
  }
}

resource containerAppsEnv 'Microsoft.App/managedEnvironments@2022-03-01' = {
  name: containerAppsEnvName
  location: location
  properties: {
    appLogsConfiguration: {
      destination: 'log-analytics'
      logAnalyticsConfiguration: {
        customerId: '' // Replace with your Log Analytics Workspace ID
        sharedKey: '' // Replace with your Log Analytics Workspace Primary Key
      }
    }
  }
}

resource managedIdentityName 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: 'smart-regression-identity'
  location: location
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
    isHnsEnabled: true
  }
}

@description('Secrets compartidos del entorno')
module secrets 'infra-secrets.bicep' = {
  name: 'sharedSecrets'
  scope: resourceGroup()
  params: {
    location: location
    containerAppsEnvName:containerAppsEnvName
    acrName:acrName
    apiCreateUrl:apiCreateUrl
    apiEvaluateUrl:apiEvaluateUrl
    azureSearchEndpoint:azureSearchEndpoint
    azureSearchIndex:azureSearchIndex
    blobContainerName:blobContainerName
    cosmosDbDatabase:cosmosDbDatabase
    cosmosDbEndpoint:cosmosDbEndpoint
    jiraToken:jiraToken
    jiraUrl:jiraUrl
    jiraUser:jiraUser
    openAiEndpoint:openAiEndpoint
    openAiKey:openAiKey
    reactAppApiUrl:reactAppApiUrl
    reactAppEnv:reactAppEnv
    storageAccountName:storageAccountName
    userAssignedIdentityName:userAssignedIdentityName
  }
}

// Module deployments for the applications
// === Apps ===

module cronUpdateRag 'cron-update-rag.bicep' = {
  name: 'cronUpdateRag'
  params: {
    appName: 'cron-update-rag'
    containerAppEnvName: containerAppsEnvName
    acrName: acr.name
    userAssignedIdentityName: managedIdentityName.name
  }
}

module apiEvaluate 'api-evaluate.bicep' = {
  name: 'apiEvaluate'
  params: {
    appName: 'api-evaluate'
    containerAppEnvName: containerAppsEnvName
    acrName: acr.name
    userAssignedIdentityName: managedIdentityName.name
  }
}

module apiCreate 'api-create.bicep' = {
  name: 'apiCreate'
  params: {
    appName: 'api-create'
    containerAppEnvName: containerAppsEnvName
    acrName: acr.name
    userAssignedIdentityName: managedIdentityName.name
  }
}

module frontReact 'front-react.bicep' = {
  name: 'frontReact'
  params: {
    appName: 'front-react'
    containerAppEnvName: containerAppsEnvName
    acrName: acr.name
    userAssignedIdentityName: managedIdentityName.name
  }
}
// === End Apps ===

output containerAppsEnvId string = containerAppsEnv.id
output storageAccountId string = storageAccount.id
output identityId string = managedIdentityName.id
output storageAccountName string = storageAccount.name
output containerAppsEnvName string = containerAppsEnv.name
output cosmosDbEndpoint string = secrets.outputs.cosmosDbEndpoint






















//-----





























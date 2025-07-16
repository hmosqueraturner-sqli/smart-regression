
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
@description('workspaceId for Log Analytics')
param workspaceIdLogAnalytics string
@description('primaryKey for Log Analytics')
param primaryKeyLogAnalytics string

resource containerEnv 'Microsoft.App/managedEnvironments@2023-05-01' existing = {
  name: containerAppsEnvName
}

resource sharedSecrets 'Microsoft.App/managedEnvironments/secrets@2023-05-01' = {
  parent: containerEnv
  name: 'sharedSecrets'
  properties: {
    secrets: [
      {
        name: 'STORAGE_ACCOUNT_NAME'
        value: storageAccountName
      }
      {
        name: 'BLOB_CONTAINER_NAME'
        value: blobContainerName
      }
      {
        name: 'COSMOSDB_ENDPOINT'
        value: cosmosDbEndpoint
      }
      {
        name: 'COSMOSDB_DATABASE'
        value: cosmosDbDatabase
      }
      {
        name: 'AZURE_SEARCH_ENDPOINT'
        value: azureSearchEndpoint
      }
      {
        name: 'AZURE_SEARCH_INDEX'
        value: azureSearchIndex
      }
      {
        name: 'OPEN_AI_ENDPOINT'
        value: openAiEndpoint
      }
      {
        name: 'OPEN_AI_key'
        value: openAiKey
      }
      {
        name: 'JIRA_URL'
        value: jiraUrl
      }
      {
        name: 'JIRA_TOKEN'
        value: jiraToken
      }
      {
        name: 'JIRA_USER'
        value: jiraUser
      }
      {
        name: 'REACT_APP_API_URL'
        value: reactAppApiUrl
      }
      {
        name: 'REACT_APP_ENV'
        value: reactAppEnv
      }
      {
        name: 'API_EVALUATE_URL'
        value: apiEvaluateUrl
      }
      {
        name: 'API_CREATE_URL'
        value: apiCreateUrl
      }
      {
        name: 'AZURE_IDENTITY_NAME'
        value: userAssignedIdentityName
      }
      {
        name: 'AZURE_CONTAINERS_REG'
        value: acrName
      }
      
      {
        name: 'WORK_SPACE_ID_LOG_ANALYTICS'
        value: workspaceIdLogAnalytics
      }
      {
        name: 'PRIMARY_KEY_LOG_ANALYTICS'
        value: primaryKeyLogAnalytics
      }
      
    ]
  }
}

// 🔁 Outputs to use in the environment
output cosmosDbEndpoint string = cosmosDbEndpoint
output openAiEndpoint string = openAiEndpoint
output jiraUrl string = jiraUrl
output storageAccountName string = storageAccountName
output reactAppApiUrl string = reactAppApiUrl


//@batchSize(1)
//module secretsModule 'secrets.bicep' = [
//  for secretName in union([], objectKeys(secrets)): {
//    name: 'secret-${secretName}'
//    params: {
//      containerAppEnvName: containerAppEnvName
//      secretName: secretName
//      secretValue: secrets[secretName]
//    }
//  }
//]



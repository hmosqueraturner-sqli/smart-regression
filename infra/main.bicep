
@description('Container Apps Environment name')
param containerAppsEnvName string = 'smart-regession-container-env'

@description('Resource group name')
param location string = resourceGroup().location

@description('Azure Storage Account name')
param storageAccountName string = 'stspaingenaipoc'

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

output containerAppsEnvId string = containerAppsEnv.id
output storageAccountId string = storageAccount.id
output identityId string = managedIdentityName.id
output storageAccountName string = storageAccount.name
output containerAppsEnvName string = containerAppsEnv.name


@description('Container Apps Environment name')
param containerAppsEnvName string = 'smart-regession-container-env'

@description('Location for the resources')
param location string = resourceGroup().location

@description('Azure Storage Account name')
param storageAccountName string = 'stspaingenaipoc'

targetScope = 'resourceGroup'
param acrName string = 'smartregessionContainerRegistry'



param projectName string = 'ragsystem'


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
  params: {
    location: location
    containerAppEnvName:containerAppsEnvName
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






















//-----





























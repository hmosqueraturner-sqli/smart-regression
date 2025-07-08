from azure.identity import DefaultAzureCredential
from azure.cosmos import CosmosClient
from azure.search.documents import SearchClient
from azure.storage.blob import BlobServiceClient
import os

def get_cosmos_client():
    endpoint = os.environ["COSMOSDB_ENDPOINT"]
    credential = DefaultAzureCredential()
    return CosmosClient(endpoint, credential)

def get_search_client():
    endpoint = os.environ["SEARCH_ENDPOINT"]
    index_name = os.environ["SEARCH_INDEX"]
    credential = DefaultAzureCredential()
    return SearchClient(endpoint=endpoint, index_name=index_name, credential=credential)

def get_blob_client():
    account_url = f"https://{os.environ['STORAGE_ACCOUNT_NAME']}.blob.core.windows.net"
    container_name = os.environ["BLOB_CONTAINER_NAME"]

    credential = DefaultAzureCredential()
    service_client = BlobServiceClient(account_url=account_url, credential=credential)
    container_client = service_client.get_container_client(container_name)

    return container_client
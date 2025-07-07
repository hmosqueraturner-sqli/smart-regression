

from azure.identity import DefaultAzureCredential
from azure.cosmos import CosmosClient
from azure.search.documents import SearchClient

def get_cosmos_client():
    """
    Returns a CosmosClient instance.
    """
    credential = DefaultAzureCredential()
    client = CosmosClient(account_url="your_account_url", credential=credential)
    return client

def get_search_client():
    """
    Returns a SearchClient instance.
    """
    credential = DefaultAzureCredential()
    client = SearchClient(endpoint="your_search_endpoint", index_name="your_index_name", credential=credential)
    return client
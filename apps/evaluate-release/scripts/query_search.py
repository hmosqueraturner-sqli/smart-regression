from shared.azure_clients import get_search_client

def search_index(query):
    client = get_search_client()
    results = client.search(query)
    return [doc for doc in results]

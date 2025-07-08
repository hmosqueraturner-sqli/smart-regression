
from azure.search.documents import SearchClient
from shared.azure_clients import get_search_client

def upload_to_search_index(docs):
    """
    Uploads documents to Azure Cognitive Search index.
    
    :param docs: List of documents to upload.
    """
    client = get_search_client()
    index_name = "your_index_name"

    for doc in docs:
        try:
            client.upload_documents([doc])
            print(f"Document {doc['id']} indexed successfully.")
        except Exception as e:
            print(f"Error indexing document {doc['id']}: {e}")

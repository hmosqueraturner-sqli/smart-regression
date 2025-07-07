
from azure.cosmos import CosmosClient
from shared.azure_clients import get_cosmos_client

def upload_to_cosmos(docs):
    """
    Uploads documents to Azure Cosmos DB.
    
    :param docs: List of documents to upload.
    """
    client = get_cosmos_client()
    database_name = "your_database_name"
    container_name = "your_container_name"

    database = client.get_database_client(database_name)
    container = database.get_container_client(container_name)

    for doc in docs:
        try:
            container.upsert_item(doc)
            print(f"Document {doc['id']} uploaded successfully.")
        except Exception as e:
            print(f"Error uploading document {doc['id']}: {e}")
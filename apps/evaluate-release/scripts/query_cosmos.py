import json
import os
from shared.azure_clients import get_cosmos_client
from shared.utils import build_query, format_test_case

def run(jql_name: str) -> str:
    client = get_cosmos_client()
    database_name = os.environ["COSMOSDB_DATABASE"]
    container_name = os.environ["COSMOSDB_CONTAINER"]

    container = client.get_database_client(database_name).get_container_client(container_name)
    query = build_query(jql_name)

    results = [format_test_case(item) for item in container.query_items(query, enable_cross_partition_query=True)]

    output_file = f"/tmp/results_{jql_name}.json"
    with open(output_file, "w") as f:
        json.dump(results, f)

    return output_file

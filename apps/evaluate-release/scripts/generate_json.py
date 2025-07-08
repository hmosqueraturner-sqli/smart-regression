import os
import json
from shared.azure_clients import get_search_client
from shared.utils import format_test_case

def run(jql_name: str) -> str:
    client = get_search_client()

    # Use 'search' find the documentos con jql_name
    results = client.search(search_text=jql_name, filter=f"jql_name eq '{jql_name}'")

    formatted_results = []
    for doc in results:
        formatted_results.append(format_test_case(doc))

    output_file = f"/tmp/results_{jql_name}_search.json"
    with open(output_file, "w") as f:
        json.dump(formatted_results, f, indent=2)

    return output_file


from get_regression_test import fecth_jira_data
from update_cosmos_db import upload_to_cosmos
from index_results import upload_to_search_index

if __name__ == "__main__":
    print("Starting Cron-Update-RAG ...")
    print("1. Fetching data from JIRA...")
    # Fetching data from JIRA
    jira_data = fecth_jira_data()
    print(f"1. Retrieved: {len(jira_data)} Test Cases from JIRA")

    print("2. Uploading data to Cosmos DB...")
    # Code to upload jira_data to Cosmos DB goes here
    upload_to_cosmos(jira_data)
    print("2. Data uploaded to Cosmos DB successfully.")

    print("3. Indexing data in Azure Cognitive Search...")
    # Code to index jira_data in Azure Cognitive Search goes here
    upload_to_search_index(jira_data)
    print("3. Data indexed in Azure Cognitive Search successfully.")

    print("JOB DONE: Cron-Update-RAG completed successfully.")
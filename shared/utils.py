def format_test_case(doc):
    return {
        "jira_key": doc.get("jira_key"),
        "name": doc.get("name"),
        "assigned": doc.get("assigned_to"),
        "status": doc.get("status")
    }

def build_query(jql_name):
    # jql filter name
    return f"SELECT * FROM c WHERE c.jql_name = '{jql_name}'"

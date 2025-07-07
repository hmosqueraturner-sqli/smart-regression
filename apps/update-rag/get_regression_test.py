
import requests
from shared.utils import format_test_case

def fecth_jira_data():
    url = "https://your-jira-instance.atlassian.net/rest/api/2/search"
    headers = {"Authorization": f"Bearer YOUR_JIRA_API_TOKEN", 
               "Content-Type": "application/json"}
    query = {
        "jql": "project = YOUR_PROJECT_KEY AND status = 'Done'",
        "fields": ["summary", "description", "assignee"]
    }
    response = requests.post(url, headers=headers, json=query)
    if response.status_code == 200:
        response.raise_for_status()
        raw_issues = response.json().get('issues', [])
        return [format_test_case(issue) for issue in raw_issues]
    else:
        return {"error": response.status_code, "message": response.text}
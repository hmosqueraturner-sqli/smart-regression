import os
import requests
from dotenv import load_dotenv

load_dotenv()

JIRA_BASE_URL = os.getenv("JIRA_BASE_URL")
JIRA_USER = os.getenv("JIRA_USER")
JIRA_TOKEN = os.getenv("JIRA_TOKEN")
PROJECT_KEY = os.getenv("JIRA_PROJECT_KEY")

def create_jira_testcases(testcases):
    headers = {
        "Content-Type": "application/json",
        "Authorization": f"Basic {JIRA_TOKEN}"
    }

    created = []
    for tc in testcases:
        payload = {
            "fields": {
                "project": {"key": PROJECT_KEY},
                "summary": tc.get("summary", "Generated test case"),
                "description": tc.get("description", ""),
                "issuetype": {"name": "Test"}
            }
        }

        response = requests.post(f"{JIRA_BASE_URL}/rest/api/2/issue", json=payload, headers=headers)
        if response.status_code == 201:
            created.append(response.json().get("key"))
        else:
            created.append({"error": response.text})

    return created

from fastapi import FastAPI, Body
from read_json import parse_testcase_input
from create_testplan import create_jira_testcases

app = FastAPI()

@app.post("/create")
def create_testcases(input_data: dict = Body(...)):
    testcases = parse_testcase_input(input_data)
    results = create_jira_testcases(testcases)
    return {"created": results}

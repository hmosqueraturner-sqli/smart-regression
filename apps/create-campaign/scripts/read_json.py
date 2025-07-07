def parse_testcase_input(data: dict):
    # testCases is a list in the JSON
    return data.get("testcases", [])

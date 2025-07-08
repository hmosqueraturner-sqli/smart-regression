export async function callEvaluateApi(jqlName) {
  const response = await fetch(process.env.REACT_APP_EVALUATE_API, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({ jql_name: jqlName }),
  });

  if (!response.ok) {
    throw new Error('Error calling evaluate API');
  }

  return response.json();
}

export async function fetchTestCasesJson() {
  const response = await fetch(process.env.REACT_APP_JSON_URL);

  if (!response.ok) {
    throw new Error('Failed to fetch test case data');
  }

  return response.json();
}

import React, { useState } from 'react';
import { callEvaluateApi, fetchTestCasesJson } from './Api';
import TestCaseList from './components/TestCaseList';

function App() {
  const [jqlName, setJqlName] = useState('');
  const [testCases, setTestCases] = useState([]);
  const [loading, setLoading] = useState(false);

  const handleEvaluate = async () => {
    setLoading(true);
    try {
      await callEvaluateApi(jqlName);
      const data = await fetchTestCasesJson();
      setTestCases(data);
    } catch (err) {
      console.error(err);
      alert('Error loading test cases');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div>
      <h1>Evaluate Release</h1>
      <input
        value={jqlName}
        onChange={(e) => setJqlName(e.target.value)}
        placeholder="JQL Filter name: "
      />
      <button onClick={handleEvaluate} disabled={loading}>
        {loading ? 'Loading...' : 'Evaluate Release'}
      </button>

      {testCases.length > 0 && (
        <div>
          <h2>Test Cases:</h2>
          <TestCaseList testCases={testCases} />
        </div>
      )}
    </div>
  );
}

export default App;

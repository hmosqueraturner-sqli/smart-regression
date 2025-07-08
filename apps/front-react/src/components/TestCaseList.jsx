import React from 'react';

const TestCaseList = ({ testCases }) => {
  return (
    <table>
      <thead>
        <tr>
          <th>JIRA Key</th>
          <th>Name</th>
          <th>Assigned</th>
          <th>Status</th>
        </tr>
      </thead>
      <tbody>
        {testCases.map((test, idx) => (
          <tr key={idx}>
            <td>{test.key}</td>
            <td>{test.name}</td>
            <td>{test.assigned}</td>
            <td>{test.status}</td>
          </tr>
        ))}
      </tbody>
    </table>
  );
};

export default TestCaseList;

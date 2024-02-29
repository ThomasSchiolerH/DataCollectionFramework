import React from 'react';
import '../styles/Dashboard.css';

const Dashboard = () => {
  return (
    <div className="dashboard">
      <h1 className="admin-dashboard-title-text">Admin Dashboard</h1>
      <div className="dashboard-grid">
        <div className="card">
          <div className="card-title">Active Users</div>
          <div className="card-content">Content goes here...</div>
        </div>
        <div className="card large">
          <div className="card-title">Users</div>
          <div className="card-content">Larger content goes here...</div>
        </div>
        <div className="card">
          <div className="card-title">Health Data</div>
          <div className="card-content">Content goes here...</div>
        </div>
        <div className="card large">
          <div className="card-title">Large Chart 2</div>
          <div className="card-content">Larger content goes here...</div>
        </div>
        {/* Add more cards as needed */}
      </div>
    </div>
  );
};

export default Dashboard;

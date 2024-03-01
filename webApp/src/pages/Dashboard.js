import React, { useState, useEffect } from 'react';
import { getUserCount } from '../services/getUserServices';
import { Link } from 'react-router-dom';
import '../styles/Dashboard.css';

const Dashboard = () => {
  const [activeUsers, setActiveUsers] = useState(0);

  useEffect(() => {
    const fetchUserCount = async () => {
      const count = await getUserCount();
      setActiveUsers(count);
    };

    fetchUserCount();
  }, []);

  return (
    <div className="dashboard">
      <h1 className="admin-dashboard-title-text">Admin Dashboard</h1>
      <div className="dashboard-grid">
        <div className="card">
          <div className="card-title"><Link to={`/users`}>Active Users</Link></div>
          <div className="card-content">{activeUsers}</div>
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
      </div>
    </div>
  );
};

export default Dashboard;

import React, { useState, useEffect } from "react";
import { getUserCount, getUserAgeDemographics, getUserGenderDemographics } from "../services/getUserServices";
import { Pie } from "react-chartjs-2";
import { Link } from "react-router-dom";
import "../styles/Dashboard.css";
import { Chart, ArcElement, Tooltip, Legend } from 'chart.js';

// Register Chart.js elements
Chart.register(ArcElement, Tooltip, Legend);

const Dashboard = () => {
  const [activeUsers, setActiveUsers] = useState(0);

  const [ageData, setAgeData] = useState({
    labels: [],
    datasets: [{ data: [], backgroundColor: ['#FF6384', '#36A2EB', '#FFCE56', '#cc65fe', '#ff6348', '#36a2eb', '#ffcd56'] }],
  });

  const [genderData, setGenderData] = useState({
    labels: [],
    datasets: [{ data: [], backgroundColor: ['#FF6384', '#36A2EB', '#FFCE56'] }],
  });

  useEffect(() => {
    const fetchUserCount = async () => {
      const count = await getUserCount();
      setActiveUsers(count);
    };

    const fetchData = async () => {
      const ageDemographics = await getUserAgeDemographics();
      const genderDemographics = await getUserGenderDemographics();

      // Process and set age demographic data
      setAgeData({
        labels: ageDemographics.map(demo => demo._id),
        datasets: [{
          data: ageDemographics.map(demo => demo.count),
          backgroundColor: ['#FF6384', '#36A2EB', '#FFCE56', '#cc65fe', '#ff6348', '#36a2eb', '#ffcd56'],
        }]
      });

      // Process and set gender demographic data
      setGenderData({
        labels: genderDemographics.map(demo => demo._id),
        datasets: [{
          data: genderDemographics.map(demo => demo.count),
          backgroundColor: ['#FF6384', '#36A2EB', '#FFCE56'],
        }]
      });
    };

    fetchUserCount();
    fetchData();
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
          <div className="card-title">Age Distribution</div>
          <div className="card-content"><Pie data={ageData} /></div>
        </div>
        <div className="card">
          <div className="card-title">Other data</div>
          <div className="card-content">blablabla</div>
        </div>
        <div className="card large">
          <div className="card-title">Gender Distribution</div>
          <div className="card-content"><Pie data={genderData} /></div>
        </div>
        {/* Other cards remain unchanged */}
      </div>
    </div>
  );
};

export default Dashboard;

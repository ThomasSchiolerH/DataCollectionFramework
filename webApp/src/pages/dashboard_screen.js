import React, { useState, useEffect } from "react";
import {
  getUserCount,
  getUserAgeDemographics,
  getUserGenderDemographics,
  getUsers,
  getProjectCount,
} from "../services/get_user_services";
import { Pie } from "react-chartjs-2";
import "../styles/dashboard_screen.css";
import { Chart, ArcElement, Tooltip, Legend } from "chart.js";
import UserTable from "../components/user_table";

Chart.register(ArcElement, Tooltip, Legend);

const Dashboard = () => {
  const [activeUsers, setActiveUsers] = useState(0);
  const [users, setUsers] = useState([]);
  const [activeProjects, setActiveProjects] = useState(0);

  const [ageData, setAgeData] = useState({
    labels: [],
    datasets: [
      {
        data: [],
        backgroundColor: [
          "#FF6384",
          "#36A2EB",
          "#FFCE56",
          "#cc65fe",
          "#ff6348",
          "#36a2eb",
          "#ffcd56",
        ],
      },
    ],
  });

  const [genderData, setGenderData] = useState({
    labels: [],
    datasets: [
      { data: [], backgroundColor: ["#FF6384", "#36A2EB", "#FFCE56"] },
    ],
  });

  // Fetch user count and user demographics on component mount
  useEffect(() => {
    const fetchUserCount = async () => {
      const count = await getUserCount();
      setActiveUsers(count);
    };

    const fetchProjectCount = async () => {
      try {
        const projectCount = await getProjectCount();
        setActiveProjects(projectCount);
      } catch (error) {
        console.error("Error fetching project count:", error);
      }
    };

    const fetchUserData = async () => {
      // Fetch users for the users list
      try {
        const usersData = await getUsers();
        setUsers(usersData);
      } catch (error) {
        console.error("Error fetching users:", error);
      }
    };

    const fetchData = async () => {
      const ageDemographics = await getUserAgeDemographics();
      const genderDemographics = await getUserGenderDemographics();

      // Process and set age demographic data
      setAgeData({
        labels: ageDemographics.map((demo) => demo._id),
        datasets: [
          {
            data: ageDemographics.map((demo) => demo.count),
            backgroundColor: [
              "#FF6384",
              "#36A2EB",
              "#FFCE56",
              "#cc65fe",
              "#ff6348",
              "#36a2eb",
              "#ffcd56",
            ],
          },
        ],
      });

      // Process gender data
      setGenderData({
        labels: genderDemographics.map((demo) => demo._id),
        datasets: [
          {
            data: genderDemographics.map((demo) => demo.count),
            backgroundColor: ["#FF6384", "#36A2EB", "#FFCE56"],
          },
        ],
      });
    };

    fetchUserCount();
    fetchProjectCount();
    fetchData();
    fetchUserData();
  }, []);

  return (
    <div className="dashboard">
      <div className="users-list">
        <h1 className="userlist-title-text">Users</h1>
        <div className="user-table-wrapper">
          <UserTable users={users} />
        </div>
      </div>
      <div className="dashboard-content">
        <h1 className="admin-dashboard-title-text">Dashboard</h1>
        <div className="dashboard-grid">
          <div className="card">
            <div className="card-title-activeusers">Active Users</div>
            <div className="card-content-activeusers">{activeUsers}</div>
          </div>
          <div className="card large">
            <div className="card-title">Age Distribution</div>
            <div className="card-content">
              <Pie data={ageData} />
            </div>
          </div>
          <div className="card">
            <div className="card-title-activeusers">Active Projects</div>
            <div className="card-content-activeusers">{activeProjects}</div>
          </div>
          <div className="card large">
            <div className="card-title">Gender Distribution</div>
            <div className="card-content">
              <Pie data={genderData} />
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Dashboard;

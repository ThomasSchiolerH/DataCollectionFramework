import React, { useState, useEffect } from "react";
import { useParams } from "react-router-dom";
import { getUserHealthData } from "../services/get_user_services";
import "../styles/UserDetails.css";

const groupHealthDataByType = (healthData) => {
  return healthData.reduce((acc, data) => {
    // If the accumulator already has the type, push to it, else create a new array
    if (!acc[data.type]) {
      acc[data.type] = [];
    }
    acc[data.type].push(data);
    return acc;
  }, {});
};

const UserDetails = () => {
  const { userId } = useParams();
  const [groupedHealthData, setGroupedHealthData] = useState({});
  const [healthData, setHealthData] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");

  useEffect(() => {
    const fetchHealthData = async () => {
      try {
        const data = await getUserHealthData(userId);
        const groupedData = groupHealthDataByType(data);
        setGroupedHealthData(groupedData);
        setLoading(false);
      } catch (err) {
        console.error("Failed to fetch health data:", err);
        setError("Failed to fetch health data");
        setLoading(false);
      }
    };

    fetchHealthData();
  }, [userId]); // Depend on userId so it refetches if that changes

  if (loading) {
    return <div>Loading...</div>;
  }

  if (error) {
    return <div>Error: {error}</div>;
  }

  return (
    <div className="user-details-container">
      <h1>User Details Page</h1>
      <p>User ID: {userId}</p>
      {Object.keys(groupedHealthData).map((type) => (
        <div key={type}>
          <h2>{type.charAt(0).toUpperCase() + type.slice(1)} Data</h2>
          <ul>
            {groupedHealthData[type].map((data, index) => (
              <li key={index}>
                Type: {data.type}, Value: {data.value} {data.unit}, Date:{" "}
                {new Date(data.date).toLocaleDateString()}
              </li>
            ))}
          </ul>
        </div>
      ))}
    </div>
  );
};

export default UserDetails;

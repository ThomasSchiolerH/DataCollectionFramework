import React, { useState, useEffect } from 'react';
import { useParams } from 'react-router-dom';
import { getUserHealthData } from '../services/getUserServices';

const UserDetails = () => {
  const { userId } = useParams();
  const [healthData, setHealthData] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');

  useEffect(() => {
    const fetchHealthData = async () => {
      try {
        const data = await getUserHealthData(userId);
        setHealthData(data);
        setLoading(false);
      } catch (err) {
        console.error('Failed to fetch health data:', err);
        setError('Failed to fetch health data');
        setLoading(false);
      }
    };

    fetchHealthData();
  }, [userId]);

  if (loading) {
    return <div>Loading...</div>;
  }

  if (error) {
    return <div>Error: {error}</div>;
  }

  return (
    <div>
      <h1>User Details Page</h1>
      <p>User ID: {userId}</p>
      <h2>Health Data</h2>
      <ul>
        {healthData.map((data, index) => (
          <li key={index}>
            Type: {data.type}, Value: {data.value} {data.unit}, Date: {new Date(data.date).toLocaleDateString()}
          </li>
        ))}
      </ul>
    </div>
  );
};

export default UserDetails;

import React, { useState } from 'react';
import axios from 'axios';
import { useNavigate } from 'react-router-dom';
const serverURL = process.env.REACT_APP_SERVER_URL;

const LoginPage = ({ onLoginSuccess }) => {
    const [email, setEmail] = useState('');
    const [password, setPassword] = useState('');
    const [error, setError] = useState('');
    const navigate = useNavigate(); // Initialize useNavigate
  
    const handleLogin = async (event) => {
      event.preventDefault();
      setError(''); // Reset error message
  
      try {
        const response = await axios.post(`${serverURL}/api/admin/signin`, { email, password });
        // Assuming your API returns the token and role in the response
        const { token, role } = response.data;
        
        if (role !== 'admin') {
          setError('You are not authorized as an admin.');
          return;
        }
  
        // Call onLoginSuccess to handle successful login
        onLoginSuccess(token);
        
        navigate('/'); // Redirect to HomePage
      } catch (err) {
        setError('Failed to login. Please check your credentials.');
      }
    };
  
    return (
      <div>
        <h2>Admin Login</h2>
        <form onSubmit={handleLogin}>
          <input
            type="email"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            placeholder="Email"
            required
          />
          <input
            type="password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            placeholder="Password"
            required
          />
          <button type="submit">Login</button>
          {error && <p>{error}</p>}
        </form>
      </div>
    );
  };
  
  export default LoginPage;
  
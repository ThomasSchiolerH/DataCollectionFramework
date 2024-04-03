import React, { useState } from 'react';
import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';
import Navbar from './components/Navbar';
import Dashboard from './pages/Dashboard';
import HomePage from './pages/HomePage';
import UserDetails from './pages/UserDetails';
import LoginPage from './pages/LoginPage';
import Analysis from './pages/Analysis';
import './styles/App.css';

function App() {
  const [authToken, setAuthToken] = useState(sessionStorage.getItem('token') || '');

  const handleLoginSuccess = (token) => {
    setAuthToken(token);
    sessionStorage.setItem('token', token); // Store token in sessionStorage
  };

  return (
    <Router>
      <div className="App">
        {authToken && <Navbar />}
        <Routes>
          <Route path="/login" element={<LoginPage onLoginSuccess={handleLoginSuccess} />} />
          <Route path="/" element={authToken ? <Navigate to="/home" /> : <Navigate to="/login" />} />
          <Route path="/home" element={authToken ? <HomePage /> : <Navigate to="/login" replace />} />
          <Route path="/dashboard" element={authToken ? <Dashboard /> : <Navigate to="/login" replace />} />
          <Route path="/user/:userId" element={authToken ? <UserDetails /> : <Navigate to="/login" replace />} />
          <Route path="/analysis/:userId" element={authToken ? <Analysis /> : <Navigate to="/login" replace />} />
        </Routes>
      </div>
    </Router>
  );
}

export default App;

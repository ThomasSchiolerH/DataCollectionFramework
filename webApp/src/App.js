import React, { useState } from 'react';
import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';
import Navbar from './components/Navbar';
import Dashboard from './pages/Dashboard';
import UsersList from './pages/UsersList';
import HomePage from './pages/HomePage';
import UserDetails from './pages/UserDetails';
import LoginPage from './pages/LoginPage';
import './styles/App.css';

function App() {
  const [authToken, setAuthToken] = useState(localStorage.getItem('token') || '');

  const handleLoginSuccess = (token) => {
    setAuthToken(token);
    localStorage.setItem('token', token); // Store token in localStorage
  };

  // Redirect to login page if not authenticated
  const RequireAuth = ({ children }) => {
    if (!authToken) {
      // User not authenticated
      return <Navigate to="/login" replace />;
    }
    return children;
  };

  return (
    <Router>
      <div className="App">
        <Navbar />
        <Routes>
          <Route path="/" element={<HomePage />} />
          <Route path="/login" element={<LoginPage onLoginSuccess={handleLoginSuccess} />} />
          {/* Protect routes using RequireAuth */}
          <Route path="/dashboard" element={<RequireAuth><Dashboard /></RequireAuth>} />
          <Route path="/users" element={<RequireAuth><UsersList /></RequireAuth>} />
          <Route path="/user/:userId" element={<RequireAuth><UserDetails /></RequireAuth>} />
        </Routes>
      </div>
    </Router>
  );
}

export default App;

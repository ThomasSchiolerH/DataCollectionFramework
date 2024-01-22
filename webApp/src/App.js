import React from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import Navbar from './components/Navbar';
import Dashboard from './pages/Dashboard';
import UsersList from './pages/UsersList';
import HomePage from './pages/HomePage';
import UserDetails from './pages/UserDetails';
import './styles/App.css';

function App() {
  return (
    <Router>
      <div className="App">
        <Navbar />
        <Routes>
          <Route path="/" element={<HomePage />} />
          <Route path="/dashboard" element={<Dashboard />} />
          <Route path="/users" element={<UsersList />} />
          <Route path="/user/:userId" element={<UserDetails />} />
        </Routes>
      </div>
    </Router>
  );
}

export default App;

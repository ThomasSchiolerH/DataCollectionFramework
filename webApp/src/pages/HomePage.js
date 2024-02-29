import React from 'react';
import { Link } from 'react-router-dom';
import '../styles/HomePage.css';

const HomePage = () => {
    return (
        <div className='home-page'>
            <h1>Welcome to the Admin Panel</h1>
            <p>Select an option to get started:</p>
            <div className='link-container'>
                <Link to="/dashboard">Go to Dashboard</Link>
            </div>
            <div className='link-container'>
                <Link to="/users">View Users</Link>
            </div>
        </div>
    );
}

export default HomePage;

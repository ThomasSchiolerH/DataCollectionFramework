import React from 'react';
import { Link } from 'react-router-dom';
import '../styles/Navbar.css';

const Navbar = () => {
    return (
        <nav className="navbar">
            <Link to="/" className="navbar-logo">Admin</Link>
            <ul className="navbar-links">
                <li><Link to="/dashboard">Dashboard</Link></li>
                <li><Link to="/users">Users</Link></li>
            </ul>
        </nav>
    );
}

export default Navbar;
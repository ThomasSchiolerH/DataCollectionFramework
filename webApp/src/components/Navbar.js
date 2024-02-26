import React from 'react';
import { NavLink } from 'react-router-dom';
import '../styles/Navbar.css';

const Navbar = () => {
    return (
        <nav className="navbar">
            <NavLink to="/" className="navbar-logo">Admin</NavLink>
            <ul className="navbar-links">
                <li>
                  <NavLink to="/dashboard" className={({ isActive }) => isActive ? 'active' : undefined}>
                    Dashboard
                  </NavLink>
                </li>
                <li>
                  <NavLink to="/users" className={({ isActive }) => isActive ? 'active' : undefined}>
                    Users
                  </NavLink>
                </li>
            </ul>
        </nav>
    );
}

export default Navbar;

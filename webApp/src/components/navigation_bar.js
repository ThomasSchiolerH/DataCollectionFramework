import React from 'react';
import { NavLink } from 'react-router-dom';
import '../styles/navigation_bar.css';

const Navbar = () => {
    return (
        <nav className="navbar">
            <NavLink to="/dashboard" className="navbar-logo">Admin</NavLink> 
            <ul className="navbar-links">
                <li>
                  <NavLink to="/dashboard" className={({ isActive }) => isActive ? 'active' : undefined}>
                    Dashboard
                  </NavLink>
                </li>
                <li>
                  <NavLink to="/customize" className={({ isActive }) => isActive ? 'active' : undefined}>
                    Customize
                  </NavLink>
                </li>
            </ul>
        </nav>
    );
}

export default Navbar;

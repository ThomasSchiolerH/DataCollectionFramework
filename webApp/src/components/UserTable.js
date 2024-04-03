import React from 'react';
import { useNavigate } from 'react-router-dom'; // Import useNavigate
import '../styles/UserTable.css';

const UserTable = ({ users }) => {
    const navigate = useNavigate(); // Initialize useNavigate

    // Function to handle row click
    const handleRowClick = (userId) => {
        navigate(`/analysis/${userId}`); // Navigate to the user-specific page
    };

    return (
        <table className="user-table">
            <thead>
                <tr>
                    <th>Name</th>
                    <th>Email</th>
                    <th>Type</th>
                </tr>
            </thead>
            <tbody>
                {users.map((user, index) => (
                    // Use onClick event to handle row click
                    <tr key={index} onClick={() => handleRowClick(user._id)} style={{ cursor: 'pointer' }}>
                        <td>{user.name}</td>
                        <td>{user.email}</td>
                        <td>{user.type}</td>
                    </tr>
                ))}
            </tbody>
        </table>
    );
}

export default UserTable;

import React from 'react';
import '../styles/UserTable.css';

const UserTable = ({ users }) => {
    return (
        <table className="user-table">
            <thead>
                <tr>
                    <th>Name</th>
                    <th>Email</th>
                </tr>
            </thead>
            <tbody>
                {users.map((user, index) => (
                    <tr key={index}>
                        <td>{user.name}</td>
                        <td>{user.email}</td>
                        {/* Add more user details as needed */}
                    </tr>
                ))}
            </tbody>
        </table>
    );
}

export default UserTable;

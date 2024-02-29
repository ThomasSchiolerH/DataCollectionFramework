import React from 'react';
import { Link } from 'react-router-dom';
import '../styles/UserTable.css';

const UserTable = ({ users }) => {
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
                    <tr key={index}>
                        <td>
                            <Link to={`/user/${user._id}`}>{user.name}</Link>
                        </td>
                        <td>{user.email}</td>
                        <td>{user.type}</td>
                    </tr>
                ))}
            </tbody>
        </table>
    );
}

export default UserTable;

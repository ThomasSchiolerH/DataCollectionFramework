import React from "react";
import { useNavigate } from "react-router-dom";
import "../styles/user_table.css";

const UserTable = ({ users }) => {
  const navigate = useNavigate();

  const handleRowClick = (userId) => {
    navigate(`/analysis/${userId}`);
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
          <tr
            key={index}
            onClick={() => handleRowClick(user._id)}
            style={{ cursor: "pointer" }}
          >
            <td>{user.name}</td>
            <td>{user.email}</td>
            <td>{user.type}</td>
          </tr>
        ))}
      </tbody>
    </table>
  );
};

export default UserTable;

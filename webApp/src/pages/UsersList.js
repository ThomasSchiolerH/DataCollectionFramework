import React, { useState, useEffect } from 'react';
import Navbar from '../components/Navbar';
import UserTable from '../components/UserTable';
import '../styles/UserTable.css';

//import { getUsers } from '../services/userService';

const UsersList = () => {
    const [users, setUsers] = useState([]);

    useEffect(() => {
        //getUsers().then(setUsers);
    }, []);

    return (
        <div>
            <h1 class="userlist-title-text">Users List</h1>
            <UserTable users={users} />
        </div>
    );
};

export default UsersList;


import React, { useState, useEffect } from 'react';
import Navbar from '../components/Navbar';
import UserTable from '../components/UserTable';
import '../styles/UserTable.css';
import { getUsers } from '../services/getUserServices';

const UsersList = () => {
    const [users, setUsers] = useState([]);

    useEffect(() => {
        const fetchData = async () => {
            try {
                const usersData = await getUsers();
                setUsers(usersData);
            } catch (error) {
                console.error('Error fetching users:', error);
            }
        };
    
        fetchData();
    }, []);
    

    return (
        <div>
            <h1 className="userlist-title-text">Users List</h1>
            <UserTable users={users} />
        </div>
    );
};

export default UsersList;



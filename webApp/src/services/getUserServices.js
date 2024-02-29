import axios from 'axios';
const serverURL = process.env.REACT_APP_SERVER_URL;

// Get user's name and email
// Assuming you have a function to get the token from localStorage
const getToken = () => localStorage.getItem('token');

export const getUsers = async () => {
    try {
        const token = getToken();
        const response = await axios.get(`${serverURL}/api/getUser`, {
          headers: {
            Authorization: `Bearer ${token}`
          }
        });
        return response.data;
    } catch (error) {
        console.error('Error fetching users:', error);
        return [];
    }
};

export const getUserHealthData = async (userId) => {
    try {
        const token = getToken(); // Reuse the getToken function to access the stored token
        const response = await axios.get(`${serverURL}/api/users/${userId}/healthData`, {
          headers: {
            Authorization: `Bearer ${token}`
          }
        });
        return response.data;
    } catch (error) {
        console.error('Error fetching health data:', error);
        throw error; // It's often useful to re-throw the error for handling by the caller
    }
};

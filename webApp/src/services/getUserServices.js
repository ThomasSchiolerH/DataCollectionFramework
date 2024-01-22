import axios from 'axios';
const serverURL = process.env.REACT_APP_SERVER_URL;

export const getUsers = async () => {
    try {
        const response = await axios.get(`${serverURL}/api/getUser`);
        return response.data;
    } catch (error) {
        console.error('Error fetching users:', error);
        return [];
    }
};

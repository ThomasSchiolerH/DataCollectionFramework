import axios from "axios";
const serverURL = process.env.REACT_APP_SERVER_URL;

const getToken = () => localStorage.getItem("token");

// Get all users
export const getUsers = async () => {
  try {
    const token = getToken();
    const response = await axios.get(`${serverURL}/api/getUser`, {
      headers: {
        Authorization: `Bearer ${token}`,
      },
    });
    return response.data;
  } catch (error) {
    console.error("Error fetching users:", error);
    return [];
  }
};

// Get user health data
export const getUserHealthData = async (userId) => {
  try {
    const token = getToken();
    const response = await axios.get(
      `${serverURL}/api/users/${userId}/healthData`,
      {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      }
    );
    return response.data;
  } catch (error) {
    console.error("Error fetching health data:", error);
    throw error; 
  }
};

// Get user count
export const getUserCount = async () => {
  try {
    const token = getToken();
    const response = await axios.get(`${serverURL}/api/getUserCount`, {
      headers: {
        Authorization: `Bearer ${token}`,
      },
    });
    return response.data.count;
  } catch (error) {
    console.error("Error fetching user count:", error);
    return 0;
  }
};

// Get project count
export const getProjectCount = async () => {
  try {
    const token = getToken();
    const response = await axios.get(
      `${serverURL}/api/getDifferentProjectsCount`,
      {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      }
    );
    return response.data.projectCount;
  } catch (error) {
    console.error("Error fetching project count:", error);
    return 0;
  }
};

// Get user age demographics
export const getUserAgeDemographics = async () => {
  try {
    const token = getToken();
    const response = await axios.get(`${serverURL}/api/userDemographics/age`, {
      headers: {
        Authorization: `Bearer ${token}`,
      },
    });
    return response.data;
  } catch (error) {
    console.error("Error fetching age demographics:", error);
    return [];
  }
};

// Get user gender demographics
export const getUserGenderDemographics = async () => {
  try {
    const token = getToken();
    const response = await axios.get(
      `${serverURL}/api/userDemographics/gender`,
      {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      }
    );
    return response.data;
  } catch (error) {
    console.error("Error fetching gender demographics:", error);
    return [];
  }
};

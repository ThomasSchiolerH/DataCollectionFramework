import axios from "axios";
const serverURL = process.env.REACT_APP_SERVER_URL;

const getToken = () => localStorage.getItem("token");

// Fetching the average health data values for each type - compare it to mood
export const fetchMoodAnalysis = async (userId) => {
  try {
    const token = getToken();
    const response = await axios.get(
      `${serverURL}/api/users/${userId}/avgHealthData`,
      {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      }
    );
    return response.data;
  } catch (error) {
    console.error("Error fetching health data:", error);
    throw error; // re-throw the error for handling by the caller
  }
};

// Fetch the analysis feedback
export const fetchMoodFeedback = async (userId) => {
  try {
    const token = getToken();
    const response = await axios.get(
      `${serverURL}/api/users/${userId}/analyseStepsMoodWeekly`,
      {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      }
    );
    return response.data;
  } catch (error) {
    console.error("Error fetching health data:", error);
    throw error; // re-throw the error for handling by the caller
  }
};
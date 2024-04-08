import React, { useState } from "react";
import axios from "axios";
import "../styles/Customize.css";

const Customize = () => {
  const [projectName, setProjectName] = useState("");
  const [usernames, setUsernames] = useState("");
  const [message, setMessage] = useState("");
  const [inputType, setInputType] = useState("");
  const [lowestValue, setLowestValue] = useState("");
  const [highestValue, setHighestValue] = useState("");
  const [enabledSensors, setEnabledSensors] = useState({
    steps: false,
    heartRate: false,
    exerciseTime: false,
    BMI: false,
  });
  const [isModalOpen, setIsModalOpen] = useState(false);
  const toggleModal = () => setIsModalOpen(!isModalOpen);

  // Define the projects array here
  const projects = ["Project 1", "Project 2", "Project 3"]; // Placeholder projects

  const handleSensorChange = (sensor) => {
    setEnabledSensors((prevSensors) => ({
      ...prevSensors,
      [sensor]: !prevSensors[sensor],
    }));
  };

  const handleSubmit = async (event) => {
    event.preventDefault();
    const serverURL = process.env.REACT_APP_SERVER_URL;

    const applyToAllUsers = usernames.trim().toLowerCase() === "all";

    const payload = applyToAllUsers
      ? {
          applyToAllUsers,
          projectName,
          message,
          inputType,
          lowestValue,
          highestValue,
          enabledSensors,
        }
      : {
          usernames: usernames.split(",").map((username) => username.trim()),
          projectName,
          message,
          inputType,
          lowestValue,
          highestValue,
          enabledSensors,
        };

    try {
      await axios.post(`${serverURL}/api/users/customInput`, payload);
      console.log("User input message updated successfully");
      setProjectName("");
      setUsernames("");
      setMessage("");
      setInputType("");
      setLowestValue("");
      setHighestValue("");
      setEnabledSensors({
        steps: false,
        heartRate: false,
        exerciseTime: false,
        BMI: false,
      });
    } catch (error) {
      console.error("Error updating user input message:", error);
    }
    setIsModalOpen(false); // Close modal after submission
  };

  return (
    <div className="customize-container">
      <div className="projects-grid">
        {projects.map((project, index) => (
          <div key={index} className="project-item">
            {project}
          </div>
        ))}
        <button className="add-project-btn" onClick={toggleModal}>
          +
        </button>
      </div>

      {isModalOpen && (
        <div className="modal active">
          {" "}
          {/* Add 'active' class when modal is open */}
          <div className="modal-content">
            <span className="close" onClick={toggleModal}>
              &times;
            </span>
            {/* Form inside modal */}
            <form onSubmit={handleSubmit} className="modal-form">
              {" "}
              {/* Use a class for styling */}
              {/* Input elements now refer to CSS for styling */}
              <input
                type="text"
                id="projectName"
                placeholder="Project Name"
                value={projectName}
                onChange={(e) => setProjectName(e.target.value)}
              />
              <input
                type="text"
                id="usernames"
                placeholder="Username, Username, Username"
                value={usernames}
                onChange={(e) => setUsernames(e.target.value)}
              />
              <input
                type="text"
                id="message"
                placeholder="Message"
                value={message}
                onChange={(e) => setMessage(e.target.value)}
              />
              <input
                type="text"
                id="inputType"
                placeholder="Input Type"
                value={inputType}
                onChange={(e) => setInputType(e.target.value)}
              />
              <input
                type="text"
                id="lowestValue"
                placeholder="Lowest Value"
                value={lowestValue}
                onChange={(e) => setLowestValue(e.target.value)}
              />
              <input
                type="text"
                id="highestValue"
                placeholder="Highest Value"
                value={highestValue}
                onChange={(e) => setHighestValue(e.target.value)}
              />
                <span style={{ fontWeight: "bold" }}>Sensors:</span>
                {Object.keys(enabledSensors).map((sensor) => (
                  <label
                    key={sensor}
                  >
                    <input
                      type="checkbox"
                      id={sensor}
                      checked={enabledSensors[sensor]}
                      onChange={() => handleSensorChange(sensor)}
                    />
                    {sensor.charAt(0).toUpperCase() + sensor.slice(1)}
                  </label>
                ))}
              <button type="submit">Submit</button>
            </form>
          </div>
        </div>
      )}
    </div>
  );
};

export default Customize;
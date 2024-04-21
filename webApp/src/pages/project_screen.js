import React, { useState, useEffect } from "react";
import axios from "axios";
import "../styles/project_screen.css";

const Customize = () => {
  const [projectName, setProjectName] = useState("");
  const [usernames, setUsernames] = useState("");
  const [message, setMessage] = useState("");
  const [inputType, setInputType] = useState("");
  const [lowestValue, setLowestValue] = useState("");
  const [highestValue, setHighestValue] = useState("");
  const [timeIntervalDays, setTimeIntervalDays] = useState("");
  const [enabledSensors, setEnabledSensors] = useState({
    steps: false,
    heartRate: false,
    exerciseTime: false,
    BMI: false,
  });
  const [isModalOpen, setIsModalOpen] = useState(false);
  const toggleModal = () => setIsModalOpen(!isModalOpen);
  const [projects, setProjects] = useState([]);

  useEffect(() => {
    const fetchProjects = async () => {
      const serverURL = process.env.REACT_APP_SERVER_URL;
      try {
        const response = await axios.get(
          `${serverURL}/api/getDifferentProjects`
        );
        setProjects(response.data);
      } catch (error) {
        console.error("Error fetching projects:", error);
      }
    };

    fetchProjects();
  }, []);

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
          projectResponse: "NotAnswered",
          timeIntervalDays: parseInt(timeIntervalDays, 10),
        }
      : {
          usernames: usernames.split(",").map((username) => username.trim()),
          projectName,
          message,
          inputType,
          lowestValue,
          highestValue,
          enabledSensors,
          projectResponse: "NotAnswered",
          timeIntervalDays: parseInt(timeIntervalDays, 10),
        };

    console.log("Payload being sent:", payload); // Add this line to check payload

    try {
      const response = await axios.post(`${serverURL}/api/users/customInput`, payload);
      console.log("Response from server:", response.data); // Log server response
      console.log("User input message updated successfully");
      setProjectName("");
      setUsernames("");
      setMessage("");
      setInputType("");
      setLowestValue("");
      setHighestValue("");
      setTimeIntervalDays("");
      setEnabledSensors({
        steps: false,
        heartRate: false,
        exerciseTime: false,
        BMI: false,
      });
    } catch (error) {
      console.error("Error updating user input message:", error);
    }
    setIsModalOpen(false);
};


  return (
    <div className="customize-container">
      <div className="projects-grid">
        {projects.map((project, index) => (
          <div key={index} className="project-item">
            <h3>{project.projectName}</h3>
            <p>
              <strong>Message:</strong> {project.message}
            </p>
            <p>
              <strong>Type:</strong> {project.inputType}
            </p>
            <p>
              <strong>Range:</strong> {project.lowestValue} -{" "}
              {project.highestValue}
            </p>
            <p>
              <strong>Users Assigned:</strong> {project.userCount}
            </p>
            <div className="sensors-info">
              <strong>Sensors Enabled:</strong>
              {Object.entries(project.enabledSensors).map(
                ([sensor, enabled], idx) => (
                  <span
                    key={idx}
                    className={`sensor-${enabled ? "enabled" : "disabled"}`}
                  >
                    {sensor}
                  </span>
                )
              )}
            </div>
          </div>
        ))}
        <button className="add-project-btn" onClick={toggleModal}>
          +
        </button>
      </div>

      {isModalOpen && (
        <div className="modal active">
          {" "}
          <div className="modal-content">
            <span className="close" onClick={toggleModal}>
              &times;
            </span>
            {/* Form inside modal */}
            <form onSubmit={handleSubmit} className="modal-form">
              {" "}
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
              <input
                type="number"
                id="timeIntervalDays"
                placeholder="Time Interval (Days)"
                value={timeIntervalDays}
                onChange={(e) => setTimeIntervalDays(e.target.value)}
              />
              <div style={{ fontWeight: "bold", marginTop: "10px" }}>
                Sensors:
              </div>
              {Object.keys(enabledSensors).map((sensor) => (
                <label key={sensor} style={{ display: "block" }}>
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

import React, { useState } from "react";
import axios from "axios";
import { useNavigate } from "react-router-dom";
import "../styles/login_screen.css";
const serverURL = process.env.REACT_APP_SERVER_URL;

const LoginPage = ({ onLoginSuccess }) => {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState("");
  const navigate = useNavigate();

  // Handle login form submission
  const handleLogin = async (event) => {
    event.preventDefault();
    setError("");

    try {
      const response = await axios.post(`${serverURL}/api/admin/signin`, {
        email,
        password,
      });
      const { token, role } = response.data;

      if (role !== "admin") {
        setError("You are not authorized as an admin.");
        return;
      }

      localStorage.setItem("token", token);

      onLoginSuccess(token);

      navigate("/dashboard");
    } catch (err) {
      setError("Failed to login. Please check your credentials.");
    }
  };

  return (
    <div className="login-container">
      <div class="login-card">
        <h2>Admin Login</h2>
        <form onSubmit={handleLogin}>
          <div class="center-wrapper">
            <input
              type="email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              placeholder="Email"
              required
            />
          </div>
          <div class="center-wrapper">
            <input
              type="password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              placeholder="Password"
              required
            />
          </div>
          <div class="center-wrapper">
            <button type="submit">Login</button>
          </div>
          {error && <p>{error}</p>}
        </form>
      </div>
    </div>
  );
};

export default LoginPage;

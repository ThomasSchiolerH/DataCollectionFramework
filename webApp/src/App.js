import React, { useState } from "react";
import {
  BrowserRouter as Router,
  Routes,
  Route,
  Navigate,
} from "react-router-dom";
import Navbar from "./components/Navigationbar";
import Dashboard from "./pages/dashboard_screen";
import UserDetails from "./pages/user_details";
import LoginPage from "./pages/login_screen";
import Analysis from "./pages/analysis_screen";
import Customize from "./pages/project_screen";
import "./styles/App.css";

function App() {
  const [authToken, setAuthToken] = useState(
    sessionStorage.getItem("token") || ""
  );

  const handleLoginSuccess = (token) => {
    setAuthToken(token);
    sessionStorage.setItem("token", token);
  };

  return (
    <Router>
      <div className="App">
        {authToken && <Navbar />}
        <Routes>
          <Route
            path="/login"
            element={<LoginPage onLoginSuccess={handleLoginSuccess} />}
          />
          <Route
            path="/"
            element={
              authToken ? <Navigate to="/dashboard" /> : <Navigate to="/login" />
            }
          />
          <Route
            path="/dashboard"
            element={
              authToken ? <Dashboard /> : <Navigate to="/login" replace />
            }
          />
          <Route
            path="/user/:userId"
            element={
              authToken ? <UserDetails /> : <Navigate to="/login" replace />
            }
          />
          <Route
            path="/analysis/:userId"
            element={
              authToken ? <Analysis /> : <Navigate to="/login" replace />
            }
          />
          <Route
            path="/customize"
            element={
              authToken ? <Customize /> : <Navigate to="/login" replace />
            }
          />
        </Routes>
      </div>
    </Router>
  );
}

export default App;

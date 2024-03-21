import React, { useState, useEffect } from "react";
import { useParams, Link } from "react-router-dom";
import {
  fetchMoodAnalysis,
  fetchMoodFeedback,
} from "../services/mood_analysis";
import "../styles/AnalysisPage.css";

const AnalysisPage = () => {
  const { userId } = useParams();
  const [analysisData, setAnalysisData] = useState(null);
  const [correlationCoefficient, setCorrelationCoefficient] = useState(null);
  const [feedback, setFeedback] = useState("");
  const [error, setError] = useState("");
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchAnalysisData = async () => {
      setLoading(true);
      try {
        const data = await fetchMoodAnalysis(userId);
        setAnalysisData(data);
        setCorrelationCoefficient(data.correlationCoefficient);
        setFeedback(data.feedback);
        setLoading(false);
      } catch (err) {
        console.error("Error fetching analysis data:", err);
        setError("Failed to fetch analysis data");
        setLoading(false);
      }
    };

    if (userId) {
      fetchAnalysisData();
    }
  }, [userId]);

  if (loading) {
    return <div className="loading">Loading...</div>;
  }

  if (error) {
    return <div className="error">Error: {error}</div>;
  }

  return (
    <div className="analysis-page-container">
      <h1>Analysis Details</h1>
      <Link to={`/user/${userId}`} className="view-details-button">
        View User Details
      </Link>
      {analysisData &&
        analysisData.map((data, index) => (
          <div key={index} className="analysis-detail">
            <div className="analysis-data-item">
              <span className="data-title">Mood:</span> {data.mood}
            </div>
            <div className="analysis-data-item">
              <span className="data-title">Average Steps:</span> {data.avgSteps}
            </div>
            <div className="analysis-data-item">
              <span className="data-title">Average Exercise Time:</span>{" "}
              {data.avgExerciseTime}
            </div>
            <div className="analysis-data-item">
              <span className="data-title">Average BMI:</span> {data.avgBMI}
            </div>
          </div>
        ))}
      {correlationCoefficient !== null && (
        <div className="correlation-feedback">
          <div className="analysis-data-item">
            <span className="data-title">Correlation Coefficient:</span>{" "}
            {correlationCoefficient}
          </div>
          <div className="analysis-data-item">
            <span className="data-title">Feedback:</span> {feedback}
          </div>
        </div>
      )}
    </div>
  );
};

export default AnalysisPage;

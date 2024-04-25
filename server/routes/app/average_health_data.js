const express = require("express");
const mongoose = require("mongoose");
const User = require("../../models/user");
const authenticate = require("../../middleware/authenticate");

// Route to get the average health data of a user
const avgHealthRouter = express.Router();

// Normalize health data type keys
const normalizeType = (type) => {
  const typeMap = {
    HEART_RATE: "HeartRate",
    steps: "Steps",
    exercise_time: "ExerciseTime",
    BMI: "BMI"
  };
  return typeMap[type] || type;
};

// Route to get the average health data of a user
avgHealthRouter.get(
  "/api/users/:userId/avgHealthData",
  authenticate,
  async (req, res) => {
    const userId = req.params.userId;

    try {
      if (req.userId !== userId && req.userRole !== "admin") {
        return res.status(403).json({ msg: "Access denied." });
      }

      const objectId = new mongoose.Types.ObjectId(userId);
      const userData = await User.aggregate([
        { $match: { _id: objectId } },
        { $project: { healthData: 1, userInputData: 1, project: 1 } },
      ]);

      if (!userData || userData.length === 0) {
        return res.status(404).json({ msg: "User data not found." });
      }

      const { healthData, userInputData, project } = userData[0];

      if (!project || !project.inputType || project.lowestValue === undefined || project.highestValue === undefined) {
        return res.status(400).json({ msg: "Incomplete user project configuration." });
      }

      const { lowestValue, highestValue, inputType } = project;

      const filteredUserInputData = userInputData.filter(input => input.type === inputType);

      const healthDataByDate = healthData.reduce((acc, item) => {
        const dateStr = new Date(item.date).toDateString();
        acc[dateStr] = acc[dateStr] || [];
        acc[dateStr].push(item);
        return acc;
      }, {});

      let moodAnalysis = Array.from(
        { length: highestValue - lowestValue + 1 },
        (_, index) => ({
          [inputType]: lowestValue + index,
          avgSteps: 0,
          avgExerciseTime: 0,
          avgHeartRate: 0,
          avgBMI: 0,
          countSteps: 0,
          countExerciseTime: 0,
          countHeartRate: 0,
          countBMI: 0,
        })
      );

      filteredUserInputData.forEach(input => {
        const dateStr = new Date(input.date).toDateString();
        const relevantHealthData = healthDataByDate[dateStr];
        if (relevantHealthData) {
          relevantHealthData.forEach(healthItem => {
            const moodIndex = input.value - lowestValue;
            if (moodIndex >= 0 && moodIndex < moodAnalysis.length) {
              const analysis = moodAnalysis[moodIndex];
              let typeFormatted = normalizeType(healthItem.type);
              if (analysis.hasOwnProperty(`avg${typeFormatted}`)) {
                analysis[`avg${typeFormatted}`] += healthItem.value;
                analysis[`count${typeFormatted}`]++;
              }
            }
          });
        }
      });

      moodAnalysis = moodAnalysis.map(item => ({
        inputType: inputType,
        moodValue: item[inputType],
        avgSteps: item.countSteps ? item.avgSteps / item.countSteps : 0,
        avgExerciseTime: item.countExerciseTime ? item.avgExerciseTime / item.countExerciseTime : 0,
        avgHeartRate: item.countHeartRate ? item.avgHeartRate / item.countHeartRate : 0,
        avgBMI: item.countBMI ? item.avgBMI / item.countBMI : 0,
      }));

      res.json({ inputType, moodAnalysis });
    } catch (error) {
      console.error("Error at avgHealthData endpoint:", error);
      res.status(500).send("Internal Server Error");
    }
  }
);

module.exports = avgHealthRouter;


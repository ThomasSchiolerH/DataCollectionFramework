const express = require("express");
const mongoose = require("mongoose");
const User = require("../../models/user");
const authenticate = require("../../middleware/authenticate");
const avgHealthRouter = express.Router();

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
      const { lowestValue, highestValue, inputType } = project;

      const filteredUserInputData = userInputData.filter(
        (input) => input.type === inputType
      );

      let moodAnalysis = Array.from(
        { length: highestValue - lowestValue + 1 },
        (_, index) => ({
          [inputType || "mood"]: lowestValue + index,
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

      filteredUserInputData.forEach((moodInput) => {
        const moodIndex = moodInput.value - lowestValue;
        if (moodIndex >= 0 && moodIndex < moodAnalysis.length) {
          healthData.forEach((healthItem) => {
            if (
              filteredUserInputData.some(
                (input) =>
                  new Date(input.date).toDateString() ===
                  new Date(healthItem.date).toDateString()
              )
            ) {
              let typeFormatted;
              const { type, value } = healthItem;

              switch (type) {
                case "HEART_RATE":
                  typeFormatted = "HeartRate";
                  break;
                case "steps":
                  typeFormatted = "Steps";
                  break;
                case "exercise_time":
                  typeFormatted = "ExerciseTime";
                  break;
                case "BMI":
                  typeFormatted = "BMI";
                  break;
                default:
                  console.error(`Unexpected type: ${type}`);
                  return;
              }

              moodAnalysis[moodIndex][`avg${typeFormatted}`] += value;
              moodAnalysis[moodIndex][`count${typeFormatted}`] += 1;
            }
          });
        }
      });

      moodAnalysis = moodAnalysis.map((item, index) => ({
        inputType: inputType || "mood",
        moodValue: lowestValue + index,
        avgSteps: item.countSteps ? item.avgSteps / item.countSteps : 0,
        avgExerciseTime: item.countExerciseTime
          ? item.avgExerciseTime / item.countExerciseTime
          : 0,
        avgHeartRate: item.countHeartRate
          ? item.avgHeartRate / item.countHeartRate
          : 0,
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

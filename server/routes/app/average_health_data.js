const express = require('express');
const mongoose = require('mongoose');
const User = require("../../models/user");
const authenticate = require('../../middleware/authenticate');
const avgHealthRouter = express.Router();

avgHealthRouter.get('/api/users/:userId/avgHealthData', authenticate, async (req, res) => {
    const userId = req.params.userId;
  
    try {
      if (req.userId !== userId && req.userRole !== 'admin') {
        return res.status(403).json({ msg: 'Access denied.' });
      }
  
      const objectId = new mongoose.Types.ObjectId(userId);
      const userData = await User.aggregate([
        { $match: { _id: objectId } },
        { $project: { healthData: 1, userInputData: 1 } }
      ]);
  
      if (!userData || userData.length === 0) {
        return res.status(404).json({ msg: 'User data not found.' });
      }
  
      const { healthData, userInputData } = userData[0];
  
      // Initialize mood analysis structure with separate counters for each type of health data
      let moodAnalysis = [1, 2, 3, 4, 5, 6].map(mood => ({
        mood,
        avgSteps: 0,
        avgExerciseTime: 0,
        avgHeartRate: 0,
        avgBMI: 0,
        countSteps: 0,
        countExerciseTime: 0,
        countHeartRate: 0,
        countBMI: 0
      }));
  
      // Aggregate health data for each mood
      userInputData.forEach(moodInput => {
        const moodIndex = moodInput.value - 1;
        healthData.forEach(healthItem => {
          if (new Date(healthItem.date).toDateString() === new Date(moodInput.date).toDateString()) {
            let typeFormatted;
            const { type, value } = healthItem;
            
            // Convert database type values to expected camelCase format
            switch (type) {
              case 'HEART_RATE':
                typeFormatted = 'HeartRate';
                break;
              case 'steps':
                typeFormatted = 'Steps';
                break;
              case 'exercise_time':
                typeFormatted = 'ExerciseTime';
                break;
              case 'BMI':
                typeFormatted = 'BMI'; // Assuming Bmi is expected based on your original code structure
                break;
              default:
                console.error(`Unexpected type: ${type}`);
                return; // Skip this iteration if the type is not recognized
            }
      
            moodAnalysis[moodIndex][`avg${typeFormatted}`] += value;
            moodAnalysis[moodIndex][`count${typeFormatted}`] += 1;
          }
        });
      });
      
      // Continue with the calculation of averages as in your original code
      moodAnalysis = moodAnalysis.map(item => ({
        mood: item.mood,
        avgSteps: item.countSteps ? item.avgSteps / item.countSteps : 0,
        avgExerciseTime: item.countExerciseTime ? item.avgExerciseTime / item.countExerciseTime : 0,
        avgHeartRate: item.countHeartRate ? item.avgHeartRate / item.countHeartRate : 0,
        avgBMI: item.countBMI ? item.avgBMI / item.countBMI : 0,
      }));
      
  
      res.json(moodAnalysis);
    } catch (error) {
      console.error('Error at avgHealthData endpoint:', error);
      res.status(500).send('Internal Server Error');
    }
  });
  
  module.exports = avgHealthRouter;

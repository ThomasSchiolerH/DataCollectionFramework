const express = require('express');
const analysisRouter = express.Router();
const User = require('../../models/user');
const authenticate = require('../../middleware/authenticate');
const dataAnalysisService = require('../../services/dataAnalysis');

// Route to get the correlation between steps and mood data
analysisRouter.get('/api/users/:userId/analyseStepsMoodWeekly', authenticate, async (req, res) => {
  const { userId } = req.params;

  try {
    if (req.userId !== userId && req.userRole !== 'admin') {
      return res.status(403).json({ msg: 'Access denied.' });
    }

    const user = await User.findById(userId);
    if (!user) {
      return res.status(404).json({ msg: 'User not found' });
    }

    const stepsData = user.healthData.filter(d => d.type === 'steps').map(d => ({
      date: d.date,
      value: d.value
    }));

    const moodData = user.userInputData.filter(d => d.type === 'mood').map(d => ({
      date: d.date,
      value: d.value
    }));

    const weeklySteps = dataAnalysisService.aggregateDataByWeek(stepsData);
    const weeklyMood = dataAnalysisService.aggregateDataByWeek(moodData);

    const alignedWeeklyData = dataAnalysisService.alignWeeklyData(weeklySteps, weeklyMood);

    const correlationCoefficient = dataAnalysisService.calculateCorrelation(alignedWeeklyData.steps, alignedWeeklyData.mood);

    if (correlationCoefficient === null) {
      return res.status(400).json({ msg: "Not enough data to calculate a correlation. Please log more steps and mood data." });
    }
    const feedback = dataAnalysisService.generateFeedback(correlationCoefficient);

    res.status(200).json({ correlationCoefficient, feedback });
  } catch (error) {
    console.error('Error in analysing steps and mood correlation weekly:', error);
    res.status(500).send('Internal Server Error');
  }
});


module.exports = analysisRouter;

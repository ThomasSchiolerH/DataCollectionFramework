const express = require('express');
const analysisRouter = express.Router();
const User = require('../../models/user');
const authenticate = require('../../middleware/authenticate');
const dataAnalysisService = require('../../services/dataAnalysis');

// First iteration endpoint to analyze steps and mood correlation for a specific user
analysisRouter.get('/api/users/:userId/analyseStepsMood', authenticate, async (req, res) => {
  const { userId } = req.params;

  try {
    if (req.userId !== userId) {
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

    // Sort data by date to align steps and mood data
    stepsData.sort((a, b) => new Date(a.date) - new Date(b.date));
    moodData.sort((a, b) => new Date(a.date) - new Date(b.date));

    // Extract values for correlation calculation
    // TODO: need to align the data by date, ensuring you're comparing the same days
    const stepsValues = stepsData.map(d => d.value);
    const moodValues = moodData.map(d => d.value);

    // Calculate correlation
    const correlationCoefficient = dataAnalysisService.calculateCorrelation(stepsValues, moodValues);

    res.status(200).json({ correlationCoefficient });
  } catch (error) {
    console.error('Error in analyzing steps and mood correlation:', error);
    res.status(500).send('Internal Server Error');
  }
});

// Weekly correlation between steps and mood
analysisRouter.get('/api/users/:userId/analyseStepsMoodWeekly', authenticate, async (req, res) => {
  const { userId } = req.params;

  try {
    if (req.userId !== userId) {
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

    // Aggregate data by week
    const weeklySteps = dataAnalysisService.aggregateDataByWeek(stepsData);
    const weeklyMood = dataAnalysisService.aggregateDataByWeek(moodData);

    // Align weekly data
    const alignedWeeklyData = dataAnalysisService.alignWeeklyData(weeklySteps, weeklyMood);

    // Calculate correlation
    const correlationCoefficient = dataAnalysisService.calculateCorrelation(alignedWeeklyData.steps, alignedWeeklyData.mood);

    res.status(200).json({ correlationCoefficient });
  } catch (error) {
    console.error('Error in analyzing steps and mood correlation weekly:', error);
    res.status(500).send('Internal Server Error');
  }
});


module.exports = analysisRouter;

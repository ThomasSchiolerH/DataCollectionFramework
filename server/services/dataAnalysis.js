const ss = require("simple-statistics");

const calculateCorrelation = (weeklySteps, weeklyMoodScores) => {
  if (weeklySteps.length < 2 || weeklyMoodScores.length < 2) {
    return null; 
  }
  return ss.sampleCorrelation(weeklySteps, weeklyMoodScores);
};

const alignWeeklyData = (weeklySteps, weeklyMood) => {
  const alignedData = {
    steps: [],
    mood: [],
  };

  Object.keys(weeklySteps).forEach((week) => {
    if (weeklyMood.hasOwnProperty(week)) {
      alignedData.steps.push(weeklySteps[week]);
      alignedData.mood.push(weeklyMood[week]);
    }
  });

  return alignedData;
};

const getWeekNumber = (date) => {
  const firstDayOfYear = new Date(date.getFullYear(), 0, 1);
  const pastDaysOfYear = (date - firstDayOfYear) / 86400000;
  return Math.ceil((pastDaysOfYear + firstDayOfYear.getDay() + 1) / 7);
};

const aggregateDataByWeek = (data) => {
  const weeklyData = {};

  data.forEach((d) => {
    const weekNum = getWeekNumber(new Date(d.date));
    if (!weeklyData[weekNum]) {
      weeklyData[weekNum] = { total: 0, count: 0 };
    }
    weeklyData[weekNum].total += d.value;
    weeklyData[weekNum].count += 1;
  });

  Object.keys(weeklyData).forEach((week) => {
    weeklyData[week] = weeklyData[week].total / weeklyData[week].count;
  });

  return weeklyData;
};

const generateFeedback = (correlationCoefficient) => {
  let feedback = "Based on our analysis, ";

  if (correlationCoefficient > 0.7) {
    feedback += "it seems that increasing your weekly steps has a strong positive impact on your mood! Keep up the good work and consider setting higher step goals to potentially boost your mood even further.";
  } else if (correlationCoefficient > 0.3) {
    feedback += "there's a moderate positive relationship between your weekly steps and mood. Increasing your activity level might help improve your mood, so try to incorporate more walking into your routine.";
  } else if (correlationCoefficient > -0.3) {
    feedback += "we couldn't find a strong correlation between your steps and mood. Factors other than physical activity might be more influential on your mood, or the relationship might not be linear. It's always good to stay active for your overall health, though!";
  } else if (correlationCoefficient > -0.7) {
    feedback += "there seems to be a moderate negative relationship between your steps and mood. This is unusual, as physical activity typically boosts mood. Consider if there might be other factors affecting how you feel, or experiment with different types of activities that might be more enjoyable or fulfilling.";
  } else {
    feedback += "there's a strong negative correlation between your steps and mood, which is quite surprising. It's important to consider other factors that might be influencing your mood. Remember, physical activity is just one part of well-being, and it's crucial to find a balance that works for you.";
  }

  return feedback;
};


module.exports = {
  calculateCorrelation, getWeekNumber, alignWeeklyData, aggregateDataByWeek, generateFeedback
};

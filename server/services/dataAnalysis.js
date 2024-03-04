const ss = require("simple-statistics");

const calculateCorrelation = (weeklySteps, weeklyMoodScores) => {
  return ss.sampleCorrelation(weeklySteps, weeklyMoodScores);
};

const alignWeeklyData = (weeklySteps, weeklyMood) => {
  const alignedData = {
    steps: [],
    mood: [],
  };

  // Assuming weeklySteps and weeklyMood are objects with week numbers as keys
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

  // Convert totals to averages for mood and keep total for steps
  Object.keys(weeklyData).forEach((week) => {
    weeklyData[week] = weeklyData[week].total / weeklyData[week].count;
  });

  return weeklyData;
};

module.exports = {
  calculateCorrelation, getWeekNumber, alignWeeklyData, aggregateDataByWeek
};

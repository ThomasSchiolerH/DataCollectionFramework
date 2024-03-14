const express = require("express");
const User = require("../../models/user");
const healthRouter = express.Router();
const moment = require('moment');
const authenticate = require("../../middleware/authenticate");


const validateData = (type, value, unit, date) => {
  if (typeof type !== 'string' || type.length === 0) {
    return 'Invalid type. Type must be a non-empty string.';
  }
  if (typeof value !== 'number' || value < 0) {
    return 'Invalid value. Value must be a non-negative number.';
  }
  if (typeof unit !== 'string' || unit.length === 0) {
    return 'Invalid unit. Unit must be a non-empty string.';
  }
  if (isNaN(Date.parse(date))) {
    return 'Invalid date format. Date must be in a valid ISO format.';
  }
  return null;
};

// Upload health data
// TODO: Fix the upload logic
healthRouter.post('/api/users/:userId/healthData', authenticate, async (req, res) => {
  const { userId } = req.params;
  const { type, value, unit, date } = req.body;
  console.log(req.body);
  // Validation
  const validationError = validateData(type, value, unit, date);
  if (validationError) {
    return res.status(400).json({ msg: validationError });
  }

  try {
    // Authorization check
    if (req.userId !== userId) {
      return res.status(403).json({ msg: 'Access denied.' });
    }

    const user = await User.findById(userId);
    if (!user) {
      return res.status(404).json({ msg: 'User not found' });
    }

    // Check if there's already an entry for the current day
    // const existingData = user.healthData.find(d => 
    //   d.date.toISOString().split('T')[0] === new Date(date).toISOString().split('T')[0] && d.type === type
    // );
    
    // if (existingData) {
    //   return res.status(409).json({ msg: `Health data for ${type} on this day already exists.` });
    // }

    // Add the new health data
    user.healthData.push({ type, value, unit, date: new Date(date) });
    await user.save();

    res.status(200).json({ msg: 'Health data added successfully' });
  } catch (error) {
    console.error('Error in adding health data:', error);
    res.status(500).send('Internal Server Error');
  }
});

// Bulk upload
healthRouter.post('/api/users/:userId/healthData/bulk', authenticate, async (req, res) => {
  const { userId } = req.params;
  // Expect an object with a 'data' property that is an array of health data objects
  const healthDataArray = req.body.data; // Adjusted to access the nested array
  const errors = [];

  if (!Array.isArray(healthDataArray)) {
    return res.status(400).json({ msg: 'Invalid data format. Expected an array.' });
  }

  try {
    const user = await User.findById(userId);
    if (!user) {
      return res.status(404).json({ msg: 'User not found' });
    }

    for (const { type, value, unit, date } of healthDataArray) {
      const validationError = validateData(type, value, unit, date);
      if (validationError) {
        errors.push(validationError);
        continue; // Skip invalid entries
      }

      // Optionally, consider adding logic here to handle duplicate data prevention based on your requirements

      user.healthData.push({ type, value, unit, date: new Date(date) });
    }

    await user.save();

    // Provide feedback on the operation, including any validation errors encountered
    if (errors.length > 0) {
      // Return a detailed response if there were any errors
      return res.status(400).json({ msg: 'Some health data could not be added due to validation errors.', errors });
    }

    res.status(200).json({ msg: 'Health data bulk added successfully' });
  } catch (error) {
    console.error('Error in adding bulk health data:', error);
    res.status(500).send('Internal Server Error');
  }
});


// Fetch health data
healthRouter.get('/api/users/:userId/healthData', authenticate, async (req, res) => {
  const { userId } = req.params;

  try {
    // Only allow admins
    if (req.userId !== userId && req.userRole !== 'admin') {
      return res.status(403).json({ msg: 'Access denied.' });
    }

    const user = await User.findById(userId, 'healthData');
    if (!user) {
      return res.status(404).json({ msg: 'User not found' });
    }

    res.status(200).json(user.healthData);
  } catch (error) {
    console.error('Error in retrieving health data:', error);
    res.status(500).send('Internal Server Error');
  }
});

// Make public
module.exports = healthRouter;
  
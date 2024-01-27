const express = require("express");
const User = require("../../models/user");
const healthRouter = express.Router();
const authenticate = require("../../middleware/authenticate");


const validateHealthData = (steps, date) => {
    if (!Number.isInteger(steps) || steps < 0) {
      return 'Invalid steps count. Steps must be a non-negative integer.';
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
  const { steps, date } = req.body;

  // Validation
  const validationError = validateHealthData(steps, date);
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
    const existingData = user.healthData.find(d => 
      d.date.toISOString().split('T')[0] === new Date(date).toISOString().split('T')[0]
    );

    if (existingData) {
      return res.status(409).json({ msg: 'Health data for this day already exists.' });
    }

    // Add the new health data
    user.healthData.push({ steps, date: new Date(date) });
    await user.save();

    res.status(200).json({ msg: 'Health data added successfully' });
  } catch (error) {
    console.error('Error in adding health data:', error);
    res.status(500).send('Internal Server Error');
  }
});


// Fetch health data
healthRouter.get('/api/users/:userId/healthData', authenticate, async (req, res) => {
    const { userId } = req.params;
  
    try {
      // Authorization check
      if (req.userId !== userId) {
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
  
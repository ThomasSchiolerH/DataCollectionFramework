const express = require("express");
const User = require("../../models/user");
const userInputRouter = express.Router();
const authenticate = require("../../middleware/authenticate");

const validateInputData = (type, value, date) => {
    if (typeof type !== 'string' || type.length === 0) {
      return 'Invalid type. Type must be a non-empty string.';
    }
    if (typeof value !== 'number' || value < 0) {
      return 'Invalid value. Value must be a non-negative number.';
    }
    if (isNaN(Date.parse(date))) {
      return 'Invalid date format. Date must be in a valid ISO format.';
    }
    return null;
  };

// Fetch health data
userInputRouter.post('/api/users/:userId/userInput', authenticate, async (req, res) => {
    const { userId } = req.params;
    const { type, value, date } = req.body;
    console.log(req.body);
    // Validation
    const validationError = validateInputData(type, value, date);
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
        d.date.toISOString().split('T')[0] === new Date(date).toISOString().split('T')[0] && d.type === type
      );
  
      if (existingData) {
        return res.status(409).json({ msg: `${type} input for this day already exists.` });
      }
  
      // Add the new health data
      user.userInputData.push({ type, value, date: new Date(date) });
      await user.save();
  
      res.status(200).json({ msg: 'User input added successfully' });
    } catch (error) {
      console.error('Error in adding user input:', error);
      res.status(500).send('Internal Server Error');
    }
  });

  // Check if user input exists for a specific date
userInputRouter.get('/api/users/:userId/hasInputForDate', authenticate, async (req, res) => {
  const { userId } = req.params;
  const { date } = req.query;

  try {
      const user = await User.findById(userId);
      if (!user) {
          return res.status(404).json({ msg: 'User not found' });
      }

      // Check if there's already an entry for the specified day
      const existingData = user.userInputData.find(d => 
          d.date.toISOString().split('T')[0] === new Date(date).toISOString().split('T')[0]
      );

      if (existingData) {
          return res.json({ hasInput: true });
      } else {
          return res.json({ hasInput: false });
      }
  } catch (error) {
      console.error('Error in checking user input:', error);
      res.status(500).send('Internal Server Error');
  }
});

userInputRouter.get('/api/users/:userId/moodInputs', authenticate, async (req, res) => {
  const { userId } = req.params;

  try {
    const user = await User.findById(userId);
    if (!user) {
      return res.status(404).json({ msg: 'User not found' });
    }

    const moodInputs = user.userInputData.filter(input => input.type === 'mood');

    return res.json({ moodInputs });
  } catch (error) {
    console.error('Error fetching mood inputs:', error);
    res.status(500).send('Internal Server Error');
  }
});

userInputRouter.patch('/api/users/:userId/updateResponse', authenticate, async (req, res) => {
  const { userId } = req.params;
  const { projectResponse } = req.body;

  if (req.userId !== userId) {
    return res.status(403).json({ msg: 'Access denied.' });
  }

  try {
    const user = await User.findByIdAndUpdate(userId, {
      "$set": {
        "userInputMessage.projectResponse": projectResponse
      }
    }, { new: true }); 

    if (!user) {
      return res.status(404).send('User not found');
    }

    res.status(200).send('Response updated successfully');
  } catch (error) {
    console.error('Error updating user response:', error);
    res.status(500).send('Internal Server Error');
  }
});
  
  // Make public
  module.exports = userInputRouter;
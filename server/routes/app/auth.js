const express = require("express");
const User = require("../../models/user");
//const bcryptjs = require("bcryptjs");
const jWebToken = require("jsonwebtoken");
const authRouter = express.Router();

const capitaliseWords = (str) => str.toLowerCase().replace(/\b(\w)/g, s => s.toUpperCase());

// Sign up route
authRouter.post("/api/signup", async (req, res) => {
  try {
    let { name, age, gender, email, password } = req.body;

    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return res.status(400).json({ msg: "Another user is using this email" });
    }

    name = capitaliseWords(name);
    //const hashedPassword = await bcryptjs.hash(password, 8);

    let user = new User({
      name,
      age,
      gender,
      email,
      password,
      //password: hashedPassword,
    });
    user = await user.save();
    res.json(user);
  } catch (e) {
    return res.status(500).json({ error: e.message });
  }
});

// // Sign in route
authRouter.post("/api/signin", async (req, res) => {
  try {
    const { email, password } = req.body;

    const user = await User.findOne({ email });
    if (!user) {
      return res.status(400).json({ msg: "User does not exist." });
    }
    //TODO: Add password encryption
    //const isPwMatch = await bcryptjs.compare(password, user.password);
    console.log(password);
    console.log(user.password);
    //console.log(isPwMatch);
    // if (!isPwMatch) {
    //   return res.status(400).json({ msg: "Incorrect password!" });
    // }
    if (password !== user.password) {
      return res.status(400).json({ msg: "Incorrect password!" });
    }
    const token = jWebToken.sign({id: user._id}, "pwKey");
    res.json({token, ...user._doc});
  } catch (e) {
    return res.status(500).json({ error: e.message });
  }
});

// Admin sign in route
authRouter.post("/api/admin/signin", async (req, res) => {
  try {
    const { email, password } = req.body;

    const user = await User.findOne({ email });
    if (!user) {
      return res.status(400).json({ msg: "User does not exist." });
    }

    //TODO: Add password encryption
    //const isPwMatch = await bcryptjs.compare(password, user.password);
    console.log(password);
    console.log(user.password);
    //console.log(isPwMatch);
    // if (!isPwMatch) {
    //   return res.status(400).json({ msg: "Incorrect password!" });
    // }

    if (password !== user.password) {
      return res.status(400).json({ msg: "Incorrect password!" });
    }

    // Check if the user is an admin
    if (user.type !== 'admin') {
      return res.status(403).json({ msg: "Access denied. This user is not an admin." });
    }

    const token = jWebToken.sign({ id: user._id, role: user.type }, "pwKey");
    // Return the token and user role
    res.json({ token, role: user.type });

  } catch (e) {
    return res.status(500).json({ error: e.message });
  }
});

// Make public
module.exports = authRouter;

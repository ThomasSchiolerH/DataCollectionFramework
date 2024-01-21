const express = require("express");
const User = require("../../models/user");
//const bcryptjs = require("bcryptjs");
const jWebToken = require("jsonwebtoken");
const authRouter = express.Router();

// Sign up route
authRouter.post("/api/signup", async (req, res) => {
  //{
  // 'name': name, 'email': email, 'password': password
  //}
  try {
    const { name, email, password } = req.body;

    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return res.status(400).json({ msg: "Another user is using this email" });
    }

    const hashedPassword = await bcryptjs.hash(password, 8);

    let user = new User({
      name,
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

// Sign in route
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

// Make public
module.exports = authRouter;

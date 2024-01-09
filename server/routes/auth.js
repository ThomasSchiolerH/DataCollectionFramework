const express = require("express");
const User = require("../models/user");

const authRouter = express.Router();

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

    let user = new User({
      name,
      email,
      password,
    });
    user = await user.save();
    res.json(user);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// Make public
module.exports = authRouter;

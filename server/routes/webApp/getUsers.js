const express = require("express");
const User = require("../../models/user");
const getUserRouter = express.Router();

// Get users route
getUserRouter.get("/api/getUser", async (req, res) => {
    try {
        const users = await User.find({}, 'name email');

        if (!users) {
            return res.status(404).json({ msg: "No users found" });
        }

        res.json(users);

    } catch (e) {
        return res.status(500).json({ error: e.message });
    }
});
// Make public
module.exports = getUserRouter;
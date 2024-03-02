const express = require("express");
const User = require("../../models/user");
const getUserRouter = express.Router();

// Get users route
getUserRouter.get("/api/getUser", async (req, res) => {
    try {
        const users = await User.find({}, 'name email type');

        if (!users) {
            return res.status(404).json({ msg: "No users found" });
        }

        res.json(users);

    } catch (e) {
        return res.status(500).json({ error: e.message });
    }
});

// Get user count route
getUserRouter.get("/api/getUserCount", async (req, res) => {
    try {
        const count = await User.countDocuments();
        res.json({ count });
    } catch (e) {
        return res.status(500).json({ error: e.message });
    }
});

getUserRouter.get("/api/userDemographics/age", async (req, res) => {
    try {
        const ageDistribution = await User.aggregate([
            {
                $group: {
                    _id: {
                        $switch: {
                            branches: [
                                { case: { $lt: ["$age", 18] }, then: "Under 18" },
                                { case: { $and: [{ $gte: ["$age", 18] }, { $lt: ["$age", 25] }] }, then: "18-24" },
                                { case: { $and: [{ $gte: ["$age", 25] }, { $lt: ["$age", 35] }] }, then: "25-34" },
                                { case: { $and: [{ $gte: ["$age", 35] }, { $lt: ["$age", 45] }] }, then: "35-44" },
                                { case: { $and: [{ $gte: ["$age", 45] }, { $lt: ["$age", 55] }] }, then: "45-54" },
                                { case: { $and: [{ $gte: ["$age", 55] }, { $lt: ["$age", 65] }] }, then: "55-64" },
                            ],
                            default: "65+"
                        }
                    },
                    count: { $sum: 1 }
                }
            },
            {
                $sort: { _id: 1 }
            }
        ]);
        res.json(ageDistribution);
    } catch (e) {
        return res.status(500).json({ error: e.message });
    }
});

// Get users demographic by gender
getUserRouter.get("/api/userDemographics/gender", async (req, res) => {
    try {
        const genderDistribution = await User.aggregate([
            {
                $group: {
                    _id: "$gender",
                    count: { $sum: 1 }
                }
            },
            {
                $sort: { _id: 1 }
            }
        ]);
        res.json(genderDistribution);
    } catch (e) {
        return res.status(500).json({ error: e.message });
    }
});

// Make public
module.exports = getUserRouter;
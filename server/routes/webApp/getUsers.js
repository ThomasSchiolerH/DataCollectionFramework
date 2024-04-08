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

getUserRouter.get("/api/users/:userId/userInputMessage", async (req, res) => {
    try {
        const userId = req.params.userId;
        const user = await User.findById(userId);

        if (!user) {
            return res.status(404).json({ msg: "User not found" });
        }

        if (user.userInputMessage) {
            return res.json(user.userInputMessage);
        } else {
            return res.status(404).json({ msg: "User input message not found" });
        }
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: error.message });
    }
});


getUserRouter.post("/api/users/customInput", async (req, res) => {
    const { applyToAllUsers, projectName, message, inputType, lowestValue, highestValue, enabledSensors } = req.body;

    try {
        if (applyToAllUsers) {
            await User.updateMany({}, {
                $set: {
                    userInputMessage: {
                        projectName,
                        message,
                        inputType,
                        lowestValue,
                        highestValue,
                        enabledSensors,
                    },
                },
            });
        } else {
            const { usernames } = req.body;
            const updatePromises = usernames.map(async (username) => {
                const user = await User.findOne({ name: username.trim() });
                if (!user) {
                    throw new Error(`User not found: ${username}`);
                }

                user.userInputMessage = {
                    projectName,
                    message,
                    inputType,
                    lowestValue,
                    highestValue,
                    enabledSensors,
                };

                return user.save();
            });

            await Promise.all(updatePromises);
        }

        res.status(200).json({ msg: "User input message updated successfully." });
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: error.message });
    }
});

// Endpoint to get different projects and its information
getUserRouter.get("/api/getDifferentProjects", async (req, res) => {
    try {
        const projects = await User.aggregate([
            {
                $match: {
                    "userInputMessage.projectName": { $exists: true, $ne: null }
                }
            },
            {
                $group: {
                    _id: "$userInputMessage.projectName",
                    message: { $first: "$userInputMessage.message" },
                    inputType: { $first: "$userInputMessage.inputType" },
                    lowestValue: { $first: "$userInputMessage.lowestValue" },
                    highestValue: { $first: "$userInputMessage.highestValue" },
                    enabledSensors: { $first: "$userInputMessage.enabledSensors" },
                    userCount: { $sum: 1 }
                }
            },
            {
                $project: {
                    _id: 0,
                    projectName: "$_id",
                    message: 1,
                    inputType: 1,
                    lowestValue: 1,
                    highestValue: 1,
                    enabledSensors: 1,
                    userCount: 1
                }
            },
            {
                $sort: { projectName: 1 }
            }
        ]);

        if (!projects || projects.length === 0) {
            return res.status(404).json({ msg: "No projects found" });
        }

        res.json(projects);

    } catch (e) {
        console.error(e);
        return res.status(500).json({ error: e.message });
    }
});

getUserRouter.get("/api/getDifferentProjectsCount", async (req, res) => {
    try {
        const projectCount = await User.aggregate([
            {
                $match: {
                    "userInputMessage.projectName": { $exists: true, $ne: null }
                }
            },
            {
                $group: {
                    _id: "$userInputMessage.projectName"
                }
            },
            {
                $group: {
                    _id: null,
                    projectCount: { $sum: 1 }
                }
            }
        ]);

        if (!projectCount || projectCount.length === 0) {
            return res.status(404).json({ msg: "No projects found" });
        }

        res.json({ projectCount: projectCount[0].projectCount });

    } catch (e) {
        console.error(e);
        return res.status(500).json({ error: e.message });
    }
});

module.exports = getUserRouter;
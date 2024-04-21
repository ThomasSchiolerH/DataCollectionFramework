const mongoose = require("mongoose");

// User Schema
const userSchema = new mongoose.Schema(
  {
    name: {
      required: true,
      type: String,
      trim: true,
    },
    age: {
      required: true,
      type: Number,
    },
    gender: {
      type: String,
      required: true,
      enum: ["Male", "Female", "Other"],
    },
    email: {
      required: true,
      type: String,
      trim: true,
      validate: {
        validator: function (value) {
          const re =
            /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\\.,;:\s@\"]+\.)+[^<>()[\]\\.,;:\s@\"]{2,})$/i;
          return re.test(value);
        },
        message: "Please specify a valid email address.",
      },
    },
    password: {
      required: true,
      type: String,
    },
    type: {
      type: String,
      default: "user",
    },
    healthData: [
      {
        type: {
          type: String,
          required: true,
        },
        value: {
          type: Number,
          required: true,
        },
        unit: {
          type: String,
          required: true,
        },
        date: {
          type: Date,
          required: true,
        },
      },
    ],
    userInputData: [
      {
        type: {
          type: String,
          required: true,
        },
        value: {
          type: Number,
          required: true,
        },
        date: {
          type: Date,
          required: true,
        },
      },
    ],
    project: {
      projectName: {
        type: String,
        required: false,
      },
      message: {
        type: String,
        required: false,
      },
      inputType: {
        type: String,
        required: false,
      },
      lowestValue: {
        type: Number,
        required: false,
      },
      highestValue: {
        type: Number,
        required: false,
      },
      messageExpiration: { 
        type: Date,
        required: false,
      },
      projectResponse: { 
        type: String,
        enum: ["Accepted", "Declined", "NotAnswered", null], 
        required: false,
      },
      enabledSensors: {
        type: Map,
        of: Boolean,
      },
    },    
  },
  {
    timestamps: true,
  }
);

const User = mongoose.model("User", userSchema);
module.exports = User;

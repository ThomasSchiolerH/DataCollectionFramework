const mongoose = require("mongoose");

const userSchema = mongoose.Schema(
  {
    name: {
      required: true,
      type: String,
      trim: true, // Remove leading and trailing spaces
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
        validator: (value) => {
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
  },
  {
    timestamps: true,
  }
);

const User = mongoose.model("User", userSchema);
module.exports = User;

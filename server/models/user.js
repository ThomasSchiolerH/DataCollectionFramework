const mongoose = require("mongoose");

const userSchema = mongoose.Schema({
  name: {
    required: true,
    type: String,
    trim: true, // Remove leading and trailing spaces
  },
  email: {
    required: true,
    type: String,
    trim: true,
    validate: {
      validator: (value) => {
        const re =
          /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\\.,;:\s@\"]+\.)+[^<>()[\]\\.,;:\s@\"]{2,})$/i;
        return value.match(re);
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
  healthData: [{
    type: { 
      type: String, 
      required: true 
    },
    value : {
      type: Number,
      required: true
    },
    unit : {
      type: String,
      required: true
    },
    date: { 
      type: Date, 
      required: true 
    },
  }],
});

const User = mongoose.model("User", userSchema);
module.exports = User;

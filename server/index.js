// Imports from packages
const express = require("express");
const mongoose = require("mongoose");

// Imports from files
const authRouter = require("./routes/auth");

// INIT
const PORT = 3000;
const app = express();
const DB = "mongodb+srv://thomas:u5jCaLhzbXFHkGUm@bachelorframework.dhooq54.mongodb.net/?retryWrites=true&w=majority"

// Middleware
app.use(express.json());
app.use(authRouter);

// Connections
mongoose
  .connect(DB)
  .then(() => {
    console.log("Connection to database successful");
  })
  .catch((e) => {
    console.log(`Error connecting to database ${e}`);
  });

app.listen(PORT, "0.0.0.0", () => {
  console.log(`connected at port ${PORT}`);
});

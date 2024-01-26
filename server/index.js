// Imports from packages
const express = require("express");
const mongoose = require("mongoose");
const cors = require('cors');

// Imports from files
const authRouter = require("./routes/app/auth");
const getUserRouter = require("./routes/webApp/getUsers");
const healthRouter = require("./routes/app/health_data");
const authenticate = require("./middleware/authenticate");

// INIT
const PORT = 3000;
const app = express();
const DB = "mongodb+srv://thomas:u5jCaLhzbXFHkGUm@bachelorframework.dhooq54.mongodb.net/?retryWrites=true&w=majority"

// Middleware
app.use(cors({
  origin: 'http://localhost:3001'
}));
app.use(express.json());
app.use(authRouter);
app.use(getUserRouter);
app.use(healthRouter);

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

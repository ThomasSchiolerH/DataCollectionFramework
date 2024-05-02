const express = require("express");
const mongoose = require("mongoose");
const cors = require("cors");

const authRouter = require("./routes/app/auth");
const getUserRouter = require("./routes/webApp/get_methods");
const healthRouter = require("./routes/app/health_data");
const authenticate = require("./middleware/authenticate");
const userInputRouter = require("./routes/app/user_input_data");
const analysisRouter = require("./routes/app/analysis");
const avgHealthRouter = require("./routes/app/average_health_data");

require("dotenv").config();
const PORT = process.env.PORT;
const app = express();
const DB = process.env.DB;

app.use(
  cors({
    origin: "http://localhost:3001",
  })
);
app.use(express.json());
app.use(authRouter);
app.use(getUserRouter);
app.use(healthRouter);
app.use(userInputRouter);
app.use(analysisRouter);
app.use(avgHealthRouter);

mongoose
  .connect(DB)
  .then(() => {
    console.log("Connection to database successful");

    const User = require("./models/user");

    User.collection.createIndex(
      { "project.messageExpiration": 1 },
      { expireAfterSeconds: 0 },
      (err, result) => {
        if (err) {
          console.error("Error creating TTL index:", err);
        } else {
          console.log("TTL index created successfully:", result);
        }
      }
    );
  })
  .catch((e) => {
    console.log(`Error connecting to database ${e}`);
  });

app.listen(PORT, "0.0.0.0", () => {
  console.log(`connected at port ${PORT}`);
});

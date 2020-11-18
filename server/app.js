// imports
const express = require('express');
const app = express();

const cors = require("cors");
const morgan = require('morgan');
const bodyParser = require('body-parser');
const mongoose = require('mongoose')
const dotenv = require('dotenv')

// configs
app.use(cors());
app.use(morgan('dev'))
dotenv.config()

// parse application/x-www-form-urlencoded
app.use(bodyParser.urlencoded({ extended: false }))
// parse application/json
app.use(bodyParser.json())

// database
mongoose.connect(`mongodb+srv://ny05:${process.env.MONGO_PASSWORD}@cluster0.1lmri.mongodb.net/chain_message?retryWrites=true&w=majority`, {
    useNewUrlParser: true,
    useUnifiedTopology: true,
    useFindAndModify: false,
    useCreateIndex: true
}, (err) => {
    if (err) throw err;
    console.log("Database Up and Running...")
});

// import routes
const userRouter  = require("./routes/User")

// setting routes
app.use("/api", userRouter);

// 404 route
app.use((req, res) => {
    res.status(404).json({
        msg: "404 Route not Found!"
    })
})

module.exports = app;
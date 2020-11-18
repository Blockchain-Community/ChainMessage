const express = require('express');
const userRouter = express.Router();
const {checkNewUserParams} = require('../middleware/User')

// model
const UserModel = require('../model/User')

//----------------------------------add new user-----------------------------------------------
userRouter.post("/add-user",checkNewUserParams, (req, res) => {
    const { userName, userAddress } = req.body;

    const newUser = {
        userName,
        userAddress
    }

    UserModel.create(newUser, (err) => {
        if (err)
            return res.status(400).json({
                errMsg: err,
            });

        res.status(200).json({
            msg: "User Added Successfully!",
        });
    });
})

//----------------------------------get all user-----------------------------------------------
userRouter.get("/get-users", (req, res) => {
    UserModel.find((err, result) => {
        if (err) return res.status(500).json({
            msg: "Internal Error"
        })
        res.status(200).json({
            users: result
        })
    })
})

module.exports = userRouter;
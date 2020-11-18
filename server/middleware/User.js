module.exports = {
    checkNewUserParams: (req, res, next) => {
        const { userName, userAddress } = req.body;
        if (userName.length === 0 || userAddress.length === 0) {
            return res.status(400).json({
                msg: "Username or User Address can't be empty!"
            })
        }
        next();
    }
}
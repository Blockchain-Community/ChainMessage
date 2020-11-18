const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const stringType = (msg) => {
    return {
        type: String,
        required: [true, msg]
    }
}
const User = new Schema({
    userAddress: stringType('User Address is must!'),
    userName: stringType('Username is required!'),
    created_at: {
        type: Date,
        default: Date.now()
    }
});

module.exports = UserModel = mongoose.model('user', User);
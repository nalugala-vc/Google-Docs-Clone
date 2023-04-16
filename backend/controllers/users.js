import User from "../models/User.js";
import jwt from "jsonwebtoken";
export const signup = async(req, res, next) => {
    try {
        const { email, name, profileURL} = req.body;

        let user = await User.findOne({ email: email});

        if(!user){
            user = new User({
                email,
                name,
                profileURL
            });
    
            user = await user.save();
        }  

        const token = jwt.sign({id: user._id},"passwordKey");

        return res.status(200).json({ user: user, token : token});

    } catch (error) {
        return res.status(500).json({ message: error.message});
    }
}

export const getUser = async (req, res) => {
    const user =await User.findById(req.user);

    res.json({ user: user, token: req.token});
}
import User from "../models/User.js";
export const signup = async(req, res, next) => {
    try {
        const { email, name, profileURL} = req.body;

        const existingUser = await User.findOne({ email: email});

        if(existingUser){
            return res.status(403).json({ message:"User already exists"});
        }

        const newUser = new User({
            email,
            name,
            profileURL
        });

        const savedUser = await newUser.save();

        return res.status(200).json({ user: savedUser});

    } catch (error) {
        return res.status(500).json({ message: error.message});
    }
}
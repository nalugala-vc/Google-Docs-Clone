import express from 'express';
import { getUser, signup } from '../controllers/users.js';
import { auth } from '../middleware/auth.js';


const userRouter = express.Router();
userRouter.post('/signup', signup);
userRouter.get('/',auth, getUser);


export default userRouter;
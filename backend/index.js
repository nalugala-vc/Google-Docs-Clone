import express from 'express';
import mongoose from 'mongoose';
import userRouter from './routes/users.js';
import cors from 'cors';

/*CONFIGURATIONS*/
const app = express();
const PORT = process.env.PORT || 3001;

app.use(cors());

/*ROUTES */
app.use(express.json());
app.use('/user', userRouter)

mongoose.connect('mongodb+srv://vanessachebukwa:BntA642PimCtGjtU@cluster0.ipnefbh.mongodb.net/GoogleDocsClone?retryWrites=true&w=majority').then(()=> app.listen(PORT)).then(()=>console.log(`Connected to database and listening on port ${PORT}`));
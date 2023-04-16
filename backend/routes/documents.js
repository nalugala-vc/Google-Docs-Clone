import express from 'express';
import { auth } from '../middleware/auth.js';
import { createDocument, getUserDocuments } from '../controllers/documents.js';

const documentRouter = express.Router();

documentRouter.post('/create',auth, createDocument);
documentRouter.get('/mydocs',auth, getUserDocuments);

export default documentRouter;
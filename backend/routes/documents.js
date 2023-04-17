import express from 'express';
import { auth } from '../middleware/auth.js';
import { createDocument, getTitle, getUserDocuments, updateTitle } from '../controllers/documents.js';

const documentRouter = express.Router();

documentRouter.post('/create',auth, createDocument);
documentRouter.get('/mydocs',auth, getUserDocuments);
documentRouter.patch('/title',auth, updateTitle);
documentRouter.get('/mydocs/title/:id',auth, getTitle);

export default documentRouter;
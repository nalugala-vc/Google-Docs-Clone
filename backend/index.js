import express from 'express';
import mongoose from 'mongoose';
import userRouter from './routes/users.js';
import cors from 'cors';
import http from 'http';
import socket from 'socket.io';
import documentRouter from './routes/documents.js';
import Document from "./models/Document.js";

/*CONFIGURATIONS*/
const app = express();
const PORT = process.env.PORT || 3001;

var server = http.createServer(app);
var io = socket(server);

app.use(cors());

/*ROUTES */
app.use(express.json());
app.use('/user', userRouter);
app.use('/document', documentRouter);

const DB =
  "mongodb+srv://vanessachebukwa:BntA642PimCtGjtU@cluster0.ipnefbh.mongodb.net/GoogleDocsClone?retryWrites=true&w=majority";

mongoose
  .connect(DB)
  .then(() => {
    console.log(`Connected to database`);
  })
  .catch((err) => {
    console.log(err);
  });

io.on("connection", (socket) => {
  socket.on("join", (documentId) => {
    socket.join(documentId);
    console.log('joined');
  });

  socket.on("typing", (data) => {
    socket.broadcast.to(data.room).emit("changes", data);
  });

  socket.on("save", (data) => {
    saveData(data);
  });
});

const saveData = async (data) => {
    let document = await Document.findById(data.room);
    document.content = data.delta;
    document = await document.save();
  };

server.listen(PORT, () => {
    console.log(`connected at port ${PORT}`);
  });

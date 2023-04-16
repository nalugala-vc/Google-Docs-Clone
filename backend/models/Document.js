import mongoose from 'mongoose';
const Schema = mongoose.Schema;

const documentSchema = new Schema({
    uid:{
        required:true,
        type: String
    },
    createdAt:{
        required:true,
        type: Number
    },
    title:{
        type: String,
        required:true,
        trim: true,
    },
    content:{
        type: Array,
        default: [],
    }
});

export default mongoose.model('Document', documentSchema);
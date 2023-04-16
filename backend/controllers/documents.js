import express from "express";
import Document from "../models/Document.js";

export const createDocument = async (req, res, next) => {
    try {
        const {createdAt, uid, title} = req.body;
        let document = new Document({
            createdAt,
            uid: req.user,
            title: "Untitled Document"
        });
        document = await document.save();

        res.json(document);
    } catch (error) {
        return res.status(500).json(error.message);
    }
}

export const getUserDocuments = async (req, res, next) => {
    try {
        let user = req.user;

        let documents = await Document.find({uid: user});

        res.json(documents);
    } catch (error) {
        return res.status(500).json(error.message);
    }
}
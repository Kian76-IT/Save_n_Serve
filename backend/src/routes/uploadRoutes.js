import express from "express";
import { upload, uploadImages } from "../controllers/uploadController.js";
import authMiddleware from "../middleware/authMiddleware.js";

const router = express.Router();

// POST /uploads  — accepts up to 10 images, returns { urls: [...] }
router.post("/", authMiddleware, upload.array("images", 10), uploadImages);

export default router;

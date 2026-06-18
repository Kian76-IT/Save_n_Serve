import express from "express";
import { upload } from "../controllers/uploadController.js";
import { checkFreshness } from "../controllers/aiController.js";
import authMiddleware from "../middleware/authMiddleware.js";

const router = express.Router();

// POST /ai/check — single image freshness check, returns { status, confidence }
router.post("/check", authMiddleware, upload.single("image"), checkFreshness);

export default router;

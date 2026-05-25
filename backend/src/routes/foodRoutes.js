import express from "express";

import {
  createFood,
  getFoodFeed,
  getFoodById,
  getMyFoods,
  updateFood,
  cancelFood,
} from "../controllers/foodController.js";

import {
  createFoodValidator,
  updateFoodValidator,
  feedQueryValidator,
} from "../validator/foodValidator.js";

import validationMiddleware from "../middleware/validationMiddleware.js";
import authMiddleware from "../middleware/authMiddleware.js";
import roleMiddleware from "../middleware/roleMiddleware.js";

const router = express.Router();

// Public — no auth needed
router.get("/feed", feedQueryValidator, validationMiddleware, getFoodFeed);

// Authenticated routes — /my MUST be registered before /:food_id to avoid shadowing
router.get(
  "/my",
  authMiddleware,
  getMyFoods
);

router.get("/:food_id", getFoodById);

// giver-only routes
router.post(
  "/",
  authMiddleware,
  roleMiddleware("giver"),
  createFoodValidator,
  validationMiddleware,
  createFood
);

router.put(
  "/:food_id",
  authMiddleware,
  roleMiddleware("giver"),
  updateFoodValidator,
  validationMiddleware,
  updateFood
);

router.delete(
  "/:food_id",
  authMiddleware,
  roleMiddleware("giver"),
  cancelFood
);

export default router;
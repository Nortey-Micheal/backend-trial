import { Router } from "express";
import { login, signup } from "../controllers/user.controller.js";

export const userRoutes = Router()

userRoutes.post('/login', login)
userRoutes.post('/signup', signup)
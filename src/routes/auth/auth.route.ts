import { Router } from "express";
import { forgotPassword, login, logOut, logoutAll, refresh, register, resetPassword, verifyEmail } from "../../controllers/auth/auth.controller.js";

const authRoutes = Router()

authRoutes.post('/register', register)
authRoutes.post('/login', login)
authRoutes.post('/refresh', refresh)
authRoutes.post('/logout', logOut)
authRoutes.post('/logout-all', logoutAll)
authRoutes.post('/forgot-password', forgotPassword)
authRoutes.post('/reset-password', resetPassword)
authRoutes.post('/verify-email',verifyEmail )

export default authRoutes
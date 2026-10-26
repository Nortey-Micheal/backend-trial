import { Router } from "express";

const authRoutes = Router()

authRoutes.post('/register', )
authRoutes.post('/login', )
authRoutes.post('/refresh', )
authRoutes.post('/logout', )
authRoutes.post('/logout-all', )
authRoutes.post('/forgot-password', )
authRoutes.post('/reset-password', )
authRoutes.post('/verify-email', )

export default authRoutes
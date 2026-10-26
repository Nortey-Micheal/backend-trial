import { Router } from "express";
import { changePassword, deleteSession, getMe, getSessions, patchMe } from "../../controllers/customers/customer.controller.js";

const customersRoutes = Router()

customersRoutes.get('/me', getMe)
customersRoutes.patch('/me', patchMe)
customersRoutes.post('/me/change-password', changePassword)
customersRoutes.get('/me/sessions', getSessions)
customersRoutes.delete('/me/sessions/:id', deleteSession)

export default customersRoutes
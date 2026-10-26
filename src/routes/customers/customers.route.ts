import { Router } from "express";

const customersRoutes = Router()

customersRoutes.get('/me', )
customersRoutes.patch('/me', )
customersRoutes.post('/me/change-password', )
customersRoutes.get('/me/sessions', )
customersRoutes.delete('/me/sessions/:id', )

export default customersRoutes
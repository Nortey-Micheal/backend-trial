import { Router } from "express";

const adminRoutes = Router()

adminRoutes.get('/users', )
adminRoutes.post('/users/:id/roles')
adminRoutes.get('/transaction-limits', )
adminRoutes.post('/transaction-limits', )
adminRoutes.post('/fee-rules', )
adminRoutes.post('/reconciliation-runs', )
adminRoutes.get('/reconciliation-runs/:id', )

export default adminRoutes
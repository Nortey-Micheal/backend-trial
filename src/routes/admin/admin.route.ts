import { Router } from "express";
import { assignRoles, createFeeRule, createLimitRule, getLimits, getReconciliationResults, manageUsers, startReconciliation } from "../../controllers/admin/admin.controller.js";

const adminRoutes = Router()

adminRoutes.get('/users', manageUsers)
adminRoutes.post('/users/:id/roles', assignRoles)
adminRoutes.get('/transaction-limits', getLimits)
adminRoutes.post('/transaction-limits', createLimitRule)
adminRoutes.post('/fee-rules', createFeeRule)
adminRoutes.post('/reconciliation-runs', startReconciliation)
adminRoutes.get('/reconciliation-runs/:id', getReconciliationResults)

export default adminRoutes
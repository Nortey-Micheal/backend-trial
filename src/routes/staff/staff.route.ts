import { Router } from "express";

const staffRoutes = Router()

staffRoutes.get('/kyc/cases', )
staffRoutes.get('/kyc/cases/:id', )
staffRoutes.post('/kyc/cases/:id/decision', )
staffRoutes.post('/deposits/:id/confirm', )
staffRoutes.post('/withdrawal/:id/process', )
staffRoutes.get('/accounts', )
staffRoutes.get('/accounts/:id/status', )
staffRoutes.post('/fraud-alerts', )
staffRoutes.post('/fraud-alerts/:id/assign', )
staffRoutes.post('/review-cases/i:d/resolve', )
staffRoutes.post('/audit-logs', )

export default staffRoutes
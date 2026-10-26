import { Router } from "express";
import { addDocRef, submitCase, viewCases } from "../../controllers/kyc/kyc.controller.js";

const kycRoutes = Router()

kycRoutes.post('/cases', submitCase)
kycRoutes.get('/cases/me', viewCases)
kycRoutes.post('/cases/:id/document', addDocRef)

export default kycRoutes
import { Router } from "express";
import { addBeneficiary, deleteBeneficiary, getBeneficiary, updateBeneficiary, verifyBeneficiary } from "../../controllers/beneficiaries/beneficiaries.controller.js";

const beneficiaryRoutes = Router()

beneficiaryRoutes.post('/', addBeneficiary)
beneficiaryRoutes.get('/', getBeneficiary)
beneficiaryRoutes.patch('/:id',updateBeneficiary )
beneficiaryRoutes.delete('/:id', deleteBeneficiary)
beneficiaryRoutes.post('/:id/verify', verifyBeneficiary)

export default beneficiaryRoutes
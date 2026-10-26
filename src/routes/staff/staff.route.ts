import { Router } from "express";
import { staffCaseDecision, staffInspectPermittedCase, staffViewCases } from "../../controllers/kyc/staff.controller.js";
import { cancelTransaction, confirmDeposit, initiateDeposit, processWithdrawal, reverseTransaction, viewTransaction } from "../../controllers/transaction/staff.controller.js";
import { accountStatus, assignFlaggedTransactionReview, recordFlaggedTransactionResolution, searchAccount, searchAuditHistory, viewFlaggedTransactions } from "../../controllers/staff/staff.controller.js";

const staffRoutes = Router()

staffRoutes.get('/kyc/cases', staffViewCases)
staffRoutes.get('/kyc/cases/:id', staffInspectPermittedCase)
staffRoutes.post('/kyc/cases/:id/decision', staffCaseDecision)
staffRoutes.post('/initiate-deposite/', initiateDeposit)
staffRoutes.post('/deposits/:id/confirm', confirmDeposit)
staffRoutes.post('/withdrawal/:id/process', processWithdrawal)
staffRoutes.post('/cancel-transaction/:id/', cancelTransaction)
staffRoutes.post('/reverse-transaction/:id/', reverseTransaction)
staffRoutes.post('/view-transaction/:id/', viewTransaction)
staffRoutes.get('/accounts', searchAccount)
staffRoutes.get('/accounts/:id/status', accountStatus)
staffRoutes.post('/fraud-alerts', viewFlaggedTransactions)
staffRoutes.post('/fraud-alerts/:id/assign', assignFlaggedTransactionReview)
staffRoutes.post('/review-cases/i:d/resolve', recordFlaggedTransactionResolution)
staffRoutes.post('/audit-logs', searchAuditHistory)

export default staffRoutes
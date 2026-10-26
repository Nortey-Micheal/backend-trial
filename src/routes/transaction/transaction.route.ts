import { Router } from "express";
import { cancelTransaction, reverseTransaction, searchTransactions, transfer, viewAccountTransaction, viewTransfer } from "../../controllers/transaction/transactions.controller.js";

const transactionsRoutes = Router()

transactionsRoutes.post('/transfer', transfer)
transactionsRoutes.get('/transfer/:id', viewTransfer)
transactionsRoutes.get('/:id', searchTransactions)
transactionsRoutes.post('/:id/cancel', cancelTransaction)
transactionsRoutes.get('/', viewAccountTransaction)
transactionsRoutes.post('/:id/reversals', reverseTransaction)

export default transactionsRoutes
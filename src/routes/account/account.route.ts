import { Router } from "express";
import { accountClosure, getAccounts, getAccountStatement, openAccount, viewAccount, viewAccountBalance } from "../../controllers/account/account.controller.js";
import { viewAccountTransaction } from "../../controllers/transaction/transactions.controller.js";

const accountRoutes = Router()

accountRoutes.post('/', openAccount)
accountRoutes.get('/', getAccounts)
accountRoutes.get('/:id', viewAccount)
accountRoutes.get('/:id/balance', viewAccountBalance)
accountRoutes.post('/:id/closure-request', accountClosure)
accountRoutes.get('/:id/statement', getAccountStatement)
accountRoutes.get('/:id/transactions',viewAccountTransaction )

export default accountRoutes
import express, { Request, Response } from 'express'
import cors from 'cors'
import dotenv from 'dotenv'
import cookieParser from 'cookie-parser'
import { userRoutes } from './routes/user.route.js'
import accountRoutes from './routes/account/account.route.js'
import adminRoutes from './routes/admin/admin.route.js'
import authRoutes from './routes/auth/auth.route.js'
import beneficiaryRoutes from './routes/beneficiaries/benecifiary.route.js'
import customersRoutes from './routes/customers/customers.route.js'
import kycRoutes from './routes/kyc/kyc.route.js'
import staffRoutes from './routes/staff/staff.route.js'
import scheduledTransfersRoutes from './routes/scheduled-transfers/scheduled_transfers.route.js'
import transactionsRoutes from './routes/transaction/transaction.route.js'

dotenv.config()

const PORT = process.env.PORT || 5050

const app = express()


//middlewares
app.use(express.json())
app.use(cookieParser())
app.use(cors())

//routes
app.use('/user', userRoutes)
app.use('/account', accountRoutes)
app.use('/admin', adminRoutes)
app.use('/auth', authRoutes)
app.use('/beneficiaries', beneficiaryRoutes)
app.use('/customers', customersRoutes)
app.use('/kyc', kycRoutes)
app.use('/scheduled-transfers', scheduledTransfersRoutes)
app.use('/staff', staffRoutes)
app.use('/transactions', transactionsRoutes)

//server launch
app.listen(PORT, () => {
  console.log(`Server is listening on port: ${PORT}`)
})

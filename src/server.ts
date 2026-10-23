import express, { Request, Response } from 'express'
import cors from 'cors'
import dotenv from 'dotenv'
import cookieParser from 'cookie-parser'
import { userRoutes } from './routes/user.route.js'

dotenv.config()

const PORT = process.env.PORT || 5050

const app = express()


//middlewares
app.use(express.json())
app.use(cookieParser())
app.use(cors())

//routes
app.use('/user', userRoutes)
app.post('/test', (_req:Request,res:Response) => res.json({message:'POST works'}))

//server launch
app.listen(PORT, () => {
  console.log(`Server is listening on port: ${PORT}`)
})

import {Request,Response} from 'express'
import { prisma } from '../lib/prisma.js'
import bcrypt from 'bcryptjs'
import validator from "validator"

type LoginBody = {email:string,password:string}

export const login = async (req:Request<{}, {}, LoginBody>,res:Response) => {
  const {email,password} = req.body

  if (!email || !password) {
    return res.status(400).json({message: 'Email and Password are needed to login'})
  }

  if (!validator.isEmail(email)) {
    return res.status(400).json({message: 'Please enter a valid email.'})
  }

  try {
    const user = await prisma.user.findUnique({where: {email}})

    if (!user) {
      return res.status(400).json({message: "Invalid email or password"})
    }
    
    const isValidPassword = await bcrypt.compare(password,user.password)
    if (!isValidPassword) {
      return res.status(400).json({message: 'Invalid email or password'})
    }
    
    return res.status(200).json({message: "Login successful", user: {...user, password: undefined}})
  } catch (error:any) {
    return res.status(500).json({message: error.message})
  }
}

export const  signup = async(req:Request,res:Response) => {
  const {name, email,password} = req.body
  if (!name || !email || !password ) {
    return res.status(400).json({message: 'Name, Email and Password are needed to signup'})
  }

  if (!validator.isEmail(email)) {
    return res.status(400).json({message: 'Please enter a valid email'})
  }

  if (!validator.isStrongPassword(password)) {
    return res.status(400).json({message: 'Please enter a strong password'})
  }

  try {
    const userExist = await prisma.user.findUnique({where: {email:email}})

    if (userExist) {
      return res.status(400).json({message: 'An account already exists with this email. Please login.'})
    }

    const hashedPassword = await bcrypt.hash(password, 12)

    const user = await prisma.user.create({data:{name, email, password:hashedPassword}})

    if (!user) {
      return res.status(500).json({message: 'Error when creating account. Please try again later.'})
    }

    return res.status(200).json({message: 'Signup successful'})
  } catch (error:any) {
    console.error(error)
    return res.status(500).json({message:'Internal server error'})
  }
  
} 
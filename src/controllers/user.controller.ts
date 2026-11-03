import {Request,Response} from 'express'
import {prisma} from '../lib/prisma.js'
import bcrypt from 'bcryptjs'
import validator from 'validator'

type LoginBody = {email:string,password:string}
type SignupBody = {first_name?:string,last_name?:string,name?:string,email:string,password:string}

const normalizeEmail=(email:string)=>email.trim().toLowerCase()

export const login=async(req:Request<{}, {}, LoginBody>,res:Response)=>{
  const {email,password}=req.body
  if(!email||!password)return res.status(400).json({message:'Email and password are required'})
  if(!validator.isEmail(email))return res.status(400).json({message:'Please enter a valid email'})
  try{
    const user=await prisma.user.findFirst({where:{email_normalized:normalizeEmail(email)}})
    if(!user||!(await bcrypt.compare(password,user.password)))return res.status(400).json({message:'Invalid email or password'})
    return res.status(200).json({message:'Login successful',user:{id:user.id,first_name:user.first_name,middle_name:user.middle_name,last_name:user.last_name,email:user.email,phone:user.phone,status:user.status}})
  }catch{
    return res.status(500).json({message:'Internal server error'})
  }
}

export const signup=async(req:Request<{}, {}, SignupBody>,res:Response)=>{
  const {email,password}=req.body
  const legacyName=req.body.name?.trim().split(/\\s+/)??[]
  const first_name=req.body.first_name?.trim()||legacyName.shift()||''
  const last_name=req.body.last_name?.trim()||legacyName.join(' ')
  if(!first_name||!last_name||!email||!password)return res.status(400).json({message:'First name, last name, email and password are required'})
  if(!validator.isEmail(email))return res.status(400).json({message:'Please enter a valid email'})
  if(!validator.isStrongPassword(password))return res.status(400).json({message:'Please enter a strong password'})
  try{
    const email_normalized=normalizeEmail(email)
    const userExist=await prisma.user.findFirst({where:{email_normalized}})
    if(userExist)return res.status(400).json({message:'An account already exists with this email. Please login.'})
    const hashedPassword=await bcrypt.hash(password,12)
    await prisma.user.create({data:{first_name,last_name,email:email.trim(),email_normalized,password:hashedPassword}})
    return res.status(201).json({message:'Signup successful'})
  }catch{
    return res.status(500).json({message:'Internal server error'})
  }
}
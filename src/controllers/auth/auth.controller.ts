import { Request, Response } from "express";
import validator from 'validator'
import { prisma } from "../../lib/prisma.js";
import bcrypt from "bcryptjs";
import jwt from 'jsonwebtoken'
import { createHash, createHmac, randomBytes, randomInt, randomUUID, timingSafeEqual } from "node:crypto";
import { Status } from "../../lib/generated/prisma/enums.js";

const ACCESS_TOKEN_TTL='15m'
const SESSION_TTL_MS=30*24*60*60*1000

const hashToken=(token:string)=>createHash('sha256').update(token).digest('hex')

export const register = async (req: Request, res: Response) => {
  const { email, phone, password, firstName, middleName, lastName, dateOfBirth } = req.body

  if (!email || !phone || !password || !firstName || !lastName || !dateOfBirth) {
    return res.status(400).json({ success: false, message: 'Please provide all required details.' })
  }

  if (typeof email !== 'string' || !validator.isEmail(email.trim())) {
    return res.status(400).json({ success: false, message: 'Please enter a valid email address.' })
  }

  if (typeof phone !== 'string' || !phone.trim()) {
    return res.status(400).json({ success: false, message: 'Please enter a valid phone number.' })
  }

  if (typeof password !== 'string' || !validator.isStrongPassword(password)) {
    return res.status(400).json({ success: false, message: 'Please enter a strong password.' })
  }

  try {
    const normalizedEmail = email.trim().toLowerCase()
    const normalizedPhone = phone.trim()

    const existingUser = await prisma.user.findFirst({
      where: {
        OR: [
          { email_normalized: normalizedEmail },
          { phone_normalized: normalizedPhone }
        ]
      },
      select: { id: true }
    })

    if (existingUser) {
      return res.status(400).json({
        success: false,
        message: 'Unable to complete registration. Please verify your details or contact customer support.'
      })
    }

    const hashedPassword = await bcrypt.hash(password, 12)
    const verification_code = randomInt(100000, 1000000);

    const hashedVerificationCode = createHmac('sha256', process.env.OTP_SECRET!)
      .update(verification_code.toString())
      .digest('hex');

    console.log('Test verification code:', verification_code);

    const expireDate = new Date(Date.now() + 15 * 60 * 1000);

    await prisma.user.create({
      data: {
        email: email.trim(),
        email_normalized: normalizedEmail,
        phone: phone.trim(),
        phone_normalized: normalizedPhone,
        password: hashedPassword,
        first_name: firstName.trim(),
        middle_name: middleName?.trim() || null,
        last_name: lastName.trim(),
        verification_code: hashedVerificationCode,
        verification_code_expires: expireDate,
        user_roles: {
          create: {
            role: {
              connect: { name: "CUSTOMER" }
            }
          }
        }
      },
      select: { id: true }
    })

    return res.status(201).json({
      success: true,
      message: 'Account has been successfully created. Please check your email and verify the signup.'
    })
  } catch (error) {
    console.error('Registration error:', error)

    return res.status(500).json({
      success: false,
      message: 'Unable to complete registration. Please try again later.'
    })
  }
}

export const login=async(req:Request,res:Response)=>{
  const {email,phone,password}=req.body

  if((!email&&!phone)||!password){
    return res.status(400).json({success:false,message:'Email or phone and password are required.'})
  }

  if(email&&phone){
    return res.status(400).json({success:false,message:'Provide either email or phone, not both.'})
  }

  if(email&&(!validator.isEmail(email.trim()))){
    return res.status(400).json({success:false,message:'Please enter a valid email address.'})
  }

  if(phone&&typeof phone!=='string'){
    return res.status(400).json({success:false,message:'Please enter a valid phone number.'})
  }

  if(typeof password!=='string'||password.length===0){
    return res.status(400).json({success:false,message:'Password is required.'})
  }

  try{
    const normalizedEmail=email?email.trim().toLowerCase():undefined
    const normalizedPhone=phone?phone.trim():undefined

    const user=await prisma.user.findUnique({
      where:normalizedEmail?{email_normalized:normalizedEmail}:{phone_normalized:normalizedPhone}
    })

    if(!user){
      return res.status(401).json({success:false,message:'Invalid login credentials.'})
    }

    const isValidPassword=await bcrypt.compare(password,user.password)

    if(!isValidPassword){
      return res.status(401).json({success:false,message:'Invalid login credentials.'})
    }

    if(!user.email_verified_at){
      return res.status(403).json({success:false,message:'Please verify your email before logging in.'})
    }

    const accessSecret=process.env.JWT_ACCESS_SECRET

    if(!accessSecret){
      throw new Error('JWT_ACCESS_SECRET is not configured')
    }

    const now=new Date()
    const sessionExpiresAt=new Date(now.getTime()+SESSION_TTL_MS)
    const refreshToken=randomBytes(64).toString('hex')
    const familyId=randomUUID()

    const session=await prisma.$transaction(async(tx)=>{
      const createdSession=await tx.session.create({
        data:{
          user_id:user.id,
          ip_address:req.ip,
          user_agent:req.get('user-agent')??null,
          expires_at:sessionExpiresAt
        }
      })

      await tx.refresh_token.create({
        data:{
          session_id:createdSession.id,
          token_hash:hashToken(refreshToken),
          family_id:familyId,
          expires_at:sessionExpiresAt
        }
      })

      await tx.user.update({
        where:{id:user.id},
        data:{last_login_at:now}
      })

      return createdSession
    })

    const accessToken=jwt.sign(
      {sid:session.id},
      accessSecret,
      {subject:user.id,expiresIn:ACCESS_TOKEN_TTL}
    )

    const roleAssignments=await prisma.user_Roles.findMany({
      where:{user_id:user.id},
      select:{role:{select:{name:true}}}
    })

    const safeUser={
      id:user.id,
      first_name:user.first_name,
      middle_name:user.middle_name,
      last_name:user.last_name,
      email:user.email,
      phone:user.phone,
      status:user.status,
      roles:roleAssignments.map(item=>item.role.name)
    }

    const isProduction=process.env.NODE_ENV==='production'

    res.cookie('accessToken',accessToken,{
      httpOnly:true,
      secure:isProduction,
      sameSite:'lax',
      maxAge:15*60*1000,
      path:'/'
    })

    res.cookie('refreshToken',refreshToken,{
      httpOnly:true,
      secure:isProduction,
      sameSite:'lax',
      maxAge:SESSION_TTL_MS,
      path:'/auth'
    })

    return res.status(200).json({
      success:true,
      message:'Login successful.',
      user:safeUser
    })
    
  }catch(error){
    console.error('Login error:',error)
    return res.status(500).json({success:false,message:'Unable to complete login. Please try again later.'})
  }
}

export const refresh = async (req:Request,res:Response) => {
  
}

export const logOut = async (req:Request,res:Response) => {
  
}

export const logoutAll = async (req:Request,res:Response) => {
  
}

export const forgotPassword = async (req:Request,res:Response) => {
  
}

export const resetPassword = async (req:Request,res:Response) => {
  
}

export const verifyEmail = async (req:Request,res:Response) => {
  const { verificationCode, email } = req.body
  const normalizedEmail = email.trim().toLowerCase()

  try {
    const user = await prisma.user.findFirst({
      where: {
        AND: {
          email_normalized: normalizedEmail,
          verification_code_expires: { gt: new Date() }
        }
      }
    })

    if (!user) {
      return res.status(404).json({success: false, message: 'Invalid or expired verification code'})
    }

    if (!user || !user.verification_code) {
      return res.status(400).json({ message: 'Invalid or expired verification code' });
    }

    const submittedHash = createHmac('sha256', process.env.OTP_SECRET!)
      .update(verificationCode)
      .digest('hex');

    const isValid = timingSafeEqual(
      Buffer.from(submittedHash, 'hex'),
      Buffer.from(user.verification_code, 'hex')
    );

    if (!isValid) {
      return res.status(400).json({ message: 'Invalid or expired verification code' });
    }

    await prisma.user.update({
      where: { id: user.id },
      data: {
        verification_code: null,
        verification_code_expires: null,
        email_verified_at: new Date()
      }
    });

    return res.status(200).json({
      success: true,
      message: 'Your email has been verified. Please log in.'
    })
  } catch (error) {
     console.error('Registration error:', error)

    return res.status(500).json({
      success: false,
      message: 'Unable to verify email. Please try again later.'
    })
  }
}
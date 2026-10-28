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

const isProduction = process.env.NODE_ENV === 'production';

const clearAuthCookies = (res: Response): void => {
  res.clearCookie('accessToken', {
    httpOnly: true,
    secure: isProduction,
    sameSite: 'lax',
    path: '/',
  });

  res.clearCookie('refreshToken', {
    httpOnly: true,
    secure: isProduction,
    sameSite: 'lax',
    path: '/auth',
  });
};

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

export const refresh = async(req:Request,res:Response)=>{
 const refreshToken = req.cookies?.refreshToken;

  if (!refreshToken || typeof refreshToken !== 'string') {
    clearAuthCookies(res);

    return res.status(401).json({
      success: false,
      message: 'Refresh token is required.',
    });
  }

  const accessSecret = process.env.JWT_ACCESS_SECRET;

  if (!accessSecret) {
    console.error('JWT_ACCESS_SECRET is not configured.');

    return res.status(500).json({
      success: false,
      message: 'Authentication service is unavailable.',
    });
  }

  try {
    const tokenHash = hashToken(refreshToken);
    const now = new Date();

    const result = await prisma.$transaction(async (tx) => {
      const storedToken = await tx.refresh_token.findUnique({
        where: { token_hash: tokenHash },
        include: {
          session: {
            include: {
              user: true,
            },
          },
        },
      });

      console.log('Refresh token state:', {
        usedAt: storedToken?.used_at,
        revokedAt: storedToken?.revoked_at,
        expiresAt: storedToken?.expires_at,
        sessionId: storedToken?.session_id,
      });

      if (!storedToken) {
        console.log('Refresh token not found in database:', tokenHash);

        return { error: 'INVALID_TOKEN' as const };
      }

      // used_at means the token has already been exchanged.
      // revoked_at means the token has been explicitly invalidated.
      // Reuse of either token may indicate theft or replay, so revoke
      // the remaining tokens in the same family and the associated session.
      if (storedToken.used_at || storedToken.revoked_at) {
        await tx.refresh_token.updateMany({
          where: {
            family_id: storedToken.family_id,
            revoked_at: null,
          },
          data: { revoked_at: now },
        });

        await tx.session.updateMany({
          where: {
            id: storedToken.session_id,
            revoked_at: null,
          },
          data: { revoked_at: now },
        });

        console.log('TOKEN_REUSE branch reached');

        return { error: 'TOKEN_REUSE' as const };
      }

      const { session } = storedToken;
      const user = session.user;

      console.log('Refresh validation:', {
        tokenExpired: storedToken.expires_at <= now,
        sessionExpired: session.expires_at <= now,
        sessionRevoked: session.revoked_at,
        userStatus: user.status,
        tokenId: storedToken.id,
        sessionId: session.id,
      });

      // Each condition checks a separate reason the session cannot
      // continue:
      //
      // Token expiry: the refresh token's own lifetime has ended.
      // Session expiry: the overall login session has expired.
      // Revoked session: the user or system has ended the session.
      // Inactive user: the account is not currently permitted to refresh.
      if (
        storedToken.expires_at <= now ||
        session.expires_at <= now ||
        session.revoked_at ||
        !['ACTIVE', 'PENDING_VERIFICATION'].includes(user.status)
      ) {
        // Invalidate any remaining refresh tokens for this session.
        await tx.refresh_token.updateMany({
          where: {
            session_id: session.id,
            revoked_at: null,
          },
          data: { revoked_at: now },
        });

        // Revoke the session only if it has not already been revoked.
        await tx.session.updateMany({
          where: {
            id: session.id,
            revoked_at: null,
          },
          data: { revoked_at: now },
        });

        return { error: 'SESSION_EXPIRED' as const };
      }

      // Atomically claim the token only if it is still unused,
      // unrevoked, and unexpired. updateMany returns the number of
      // rows updated, which helps detect a concurrent refresh request.
      const claimedToken = await tx.refresh_token.updateMany({
        where: {
          id: storedToken.id,
          used_at: null,
          revoked_at: null,
          expires_at: { gt: now },
        },
        data: { used_at: now },
      });

      // Throwing rolls back this transaction. A separate reuse-handling
      // step is needed to revoke the family reliably after that rollback.
      if (claimedToken.count !== 1) {
        // Abort the transaction so a concurrent request cannot
        // accidentally commit a partially rotated token.
        throw new Error('REFRESH_TOKEN_CONCURRENT_USE');
      }

      // Generate a replacement token using cryptographically secure
      // randomness. Never store this raw token in the database.
      const newRefreshToken = randomBytes(64).toString('hex');

      await tx.refresh_token.create({
        data: {
          session_id: session.id,
          token_hash: hashToken(newRefreshToken),
          family_id: storedToken.family_id,
          expires_at: session.expires_at, // Do not let a replacement token outlive its session.
        },
      });

      // Record activity for session tracking.
      await tx.session.update({
        where: { id: session.id },
        data: { last_seen_at: now },
      });

      // Return the raw replacement token only to the controller so it
      // can set the cookie after the database transaction commits.
      return {
        refreshToken: newRefreshToken,
        sessionId: session.id,
        userId: user.id,
        sessionExpiresAt: session.expires_at,
      };
    },
    {
      maxWait: 10_000,
      timeout: 15_000,
    });

    if ('error' in result) {
      clearAuthCookies(res);

      return res.status(401).json({
        success: false,
        message: 'Session expired or invalid. Please log in again.',
      });
    }

    console.log(result)

    const accessToken = jwt.sign(
      { sid: result.sessionId },
      accessSecret,
      {
        subject: result.userId!,
        expiresIn: ACCESS_TOKEN_TTL,
      },
    );

    const remainingSessionTime =
      result?.sessionExpiresAt?.getTime()! - Date.now();

    res.cookie('accessToken', accessToken, {
      httpOnly: true,
      secure: isProduction,
      sameSite: 'lax',
      maxAge: 15 * 60 * 1000,
      path: '/',
    });

    res.cookie('refreshToken', result.refreshToken, {
      httpOnly: true,
      secure: isProduction,
      sameSite: 'lax',
      maxAge: Math.max(0, Math.min(SESSION_TTL_MS, remainingSessionTime)),
      path: '/auth',
    });

    return res.status(200).json({
      success: true,
      message: 'Session refreshed successfully.',
    });
  } catch (error) {
    console.error('Refresh error:', error);

    clearAuthCookies(res);

    return res.status(500).json({
      success: false,
      message: 'Unable to refresh session. Please try again later.',
    });
  }
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
import type { Request,Response,NextFunction } from "express";
import type { ZodType } from "zod";
export const validateBody=(schema:ZodType)=>(req:Request,res:Response,next:NextFunction)=>{const parsed=schema.safeParse(req.body);if(!parsed.success)return res.status(400).json({success:false,message:"Invalid request."});req.body=parsed.data;next();};
export const validateQuery=(schema:ZodType)=>(req:Request,res:Response,next:NextFunction)=>{const parsed=schema.safeParse(req.query);if(!parsed.success)return res.status(400).json({success:false,message:"Invalid query."});res.locals.validatedQuery=parsed.data;next();};

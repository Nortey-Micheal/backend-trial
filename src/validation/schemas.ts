import { z } from "zod";
const name=z.string().trim().min(1).max(80).regex(/^[\p{L}\p{M} .'-]+$/u);
const phone=z.string().trim().min(7).max(20).regex(/^\+?[0-9]{7,19}$/);
const password=z.string().min(12).max(128).regex(/[a-z]/).regex(/[A-Z]/).regex(/[0-9]/).regex(/[^A-Za-z0-9]/);
export const registerSchema=z.object({email:z.string().trim().email().max(254),phone,password,firstName:name,middleName:name.optional(),lastName:name,dateOfBirth:z.string().regex(/^\\d{4}-\\d{2}-\\d{2}$/).refine(v=>{const d=new Date(v);return !Number.isNaN(d.getTime())&&d.toISOString().slice(0,10)===v&&d<new Date()},"Date of birth must be a valid past date")}).strict();
export const loginSchema=z.object({email:z.string().trim().email().max(254).optional(),phone:phone.optional(),password:z.string().min(1).max(128)}).strict().refine(v=>Boolean(v.email)!==Boolean(v.phone),"Provide exactly one login identifier");
export const transferSchema=z.object({destinationWalletId:z.string().uuid(),amountMinor:z.number().int().positive().max(Number.MAX_SAFE_INTEGER),currency:z.string().length(3).regex(/^[A-Z]{3}$/),description:z.string().trim().max(160).optional()}).strict();
export const paginationSchema=z.object({limit:z.coerce.number().int().min(1).max(100).default(20),cursor:z.string().uuid().optional()}).strict();
export const idempotencyKeySchema=z.string().min(16).max(128).regex(/^[A-Za-z0-9._:-]+$/);

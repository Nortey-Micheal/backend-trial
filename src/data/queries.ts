import type { Prisma,PrismaClient } from "../lib/generated/prisma/client.js";
type Db=PrismaClient|Prisma.TransactionClient;
// Structured Prisma filters parameterize values. Never concatenate user input into raw SQL.
export const findUserByEmail=(db:Db,email:string)=>db.user.findUnique({where:{email_normalized:email.toLowerCase().trim()}});
export const findUserByPhone=(db:Db,phone:string)=>db.user.findUnique({where:{phone_normalized:phone.trim()}});
export const findOwnedWallet=(db:Db,walletId:string,userId:string)=>db.bank_Account.findFirst({where:{id:walletId,accountHolders:{some:{customer:{user_id:userId},can_view:true,ended_at:null}}}});
export const listUserTransactions=(db:Db,userId:string,limit:number)=>db.transaction.findMany({where:{initiated_by:userId},orderBy:{created_at:"desc"},take:Math.min(Math.max(limit,1),100),select:{id:true,reference:true,type:true,status:true,amount:true,currency_code:true,created_at:true}});

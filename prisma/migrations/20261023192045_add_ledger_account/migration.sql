/*
  Warnings:

  - Added the required column `ledger_AccountId` to the `Customer` table without a default value. This is not possible if the table is not empty.

*/
-- CreateEnum
CREATE TYPE "Ledger_Account_Status" AS ENUM ('ACTIVE', 'INACTIVE');

-- CreateEnum
CREATE TYPE "Account_Type" AS ENUM ('ASSET', 'LIABILITY', 'EQUITY', 'REVENUE', 'EXPENSE');

-- AlterTable
ALTER TABLE "Customer" ADD COLUMN     "ledger_AccountId" TEXT NOT NULL,
ALTER COLUMN "created_at" SET DEFAULT CURRENT_TIMESTAMP;

-- CreateTable
CREATE TABLE "Ledger_Account" (
    "id" TEXT NOT NULL,
    "code" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "account_type" "Account_Type" NOT NULL,
    "currency_code" TEXT NOT NULL,
    "bank_account_id" TEXT,
    "is_system_account" BOOLEAN NOT NULL,
    "status" "Ledger_Account_Status" NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Ledger_Account_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "Customer" ADD CONSTRAINT "Customer_ledger_AccountId_fkey" FOREIGN KEY ("ledger_AccountId") REFERENCES "Ledger_Account"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Ledger_Account" ADD CONSTRAINT "Ledger_Account_bank_account_id_fkey" FOREIGN KEY ("bank_account_id") REFERENCES "Bank_Account"("id") ON DELETE SET NULL ON UPDATE CASCADE;

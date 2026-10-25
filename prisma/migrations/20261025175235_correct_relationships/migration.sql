/*
  Warnings:

  - You are about to drop the column `account_id` on the `Ledger_Postings` table. All the data in the column will be lost.
  - You are about to drop the column `idempotency_KeysId` on the `Transaction` table. All the data in the column will be lost.
  - A unique constraint covering the columns `[account_id]` on the table `Account_Balance_Projection` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[idempotency_Key_Id]` on the table `Transaction` will be added. If there are existing duplicate values, this will fail.
  - Changed the type of `account_type` on the `Ledger_Account` table. No cast exists, the column would be dropped and recreated, which cannot be done if there is data, since the column is required.
  - Added the required column `idempotency_Key_Id` to the `Transaction` table without a default value. This is not possible if the table is not empty.
  - Changed the type of `account_type` on the `Transaction_Limit` table. No cast exists, the column would be dropped and recreated, which cannot be done if there is data, since the column is required.

*/
-- CreateEnum
CREATE TYPE "Ledger_Account_Type" AS ENUM ('ASSET', 'LIABILITY', 'EQUITY', 'REVENUE', 'EXPENSE');

-- DropForeignKey
ALTER TABLE "Kyc_Case" DROP CONSTRAINT "Kyc_Case_reviewed_by_fkey";

-- DropForeignKey
ALTER TABLE "Ledger_Postings" DROP CONSTRAINT "Ledger_Postings_account_id_fkey";

-- DropForeignKey
ALTER TABLE "Transaction" DROP CONSTRAINT "Transaction_idempotency_KeysId_fkey";

-- DropIndex
DROP INDEX "Transaction_initiated_by_key";

-- AlterTable
ALTER TABLE "Account_Balance_Projection" ALTER COLUMN "ledger_balance" SET DATA TYPE BIGINT,
ALTER COLUMN "available_balance" SET DATA TYPE BIGINT;

-- AlterTable
ALTER TABLE "Account_Hold" ALTER COLUMN "amount" SET DATA TYPE BIGINT;

-- AlterTable
ALTER TABLE "Fee_Rule" ALTER COLUMN "fee_value" SET DATA TYPE BIGINT,
ALTER COLUMN "minimum_fee" SET DATA TYPE BIGINT,
ALTER COLUMN "maximum_fee" SET DATA TYPE BIGINT;

-- AlterTable
ALTER TABLE "Kyc_Case" ALTER COLUMN "reviewed_by" DROP NOT NULL;

-- AlterTable
ALTER TABLE "Ledger_Account" DROP COLUMN "account_type",
ADD COLUMN     "account_type" "Ledger_Account_Type" NOT NULL;

-- AlterTable
ALTER TABLE "Ledger_Postings" DROP COLUMN "account_id",
ADD COLUMN     "bank_AccountId" TEXT,
ALTER COLUMN "amount" SET DATA TYPE BIGINT;

-- AlterTable
ALTER TABLE "Transaction" DROP COLUMN "idempotency_KeysId",
ADD COLUMN     "idempotency_Key_Id" TEXT NOT NULL;

-- AlterTable
ALTER TABLE "Transaction_Limit" DROP COLUMN "account_type",
ADD COLUMN     "account_type" "AccountType" NOT NULL,
ALTER COLUMN "max_single_amount" SET DATA TYPE BIGINT,
ALTER COLUMN "max_daily_amount" SET DATA TYPE BIGINT,
ALTER COLUMN "max_daily_count" SET DATA TYPE BIGINT;

-- DropEnum
DROP TYPE "Account_Type";

-- CreateIndex
CREATE UNIQUE INDEX "Account_Balance_Projection_account_id_key" ON "Account_Balance_Projection"("account_id");

-- CreateIndex
CREATE UNIQUE INDEX "Transaction_idempotency_Key_Id_key" ON "Transaction"("idempotency_Key_Id");

-- AddForeignKey
ALTER TABLE "Beneficiary" ADD CONSTRAINT "Beneficiary_bank_account_id_fkey" FOREIGN KEY ("bank_account_id") REFERENCES "Bank_Account"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Kyc_Case" ADD CONSTRAINT "Kyc_Case_reviewed_by_fkey" FOREIGN KEY ("reviewed_by") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Ledger_Postings" ADD CONSTRAINT "Ledger_Postings_bank_AccountId_fkey" FOREIGN KEY ("bank_AccountId") REFERENCES "Bank_Account"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Transaction" ADD CONSTRAINT "Transaction_idempotency_Key_Id_fkey" FOREIGN KEY ("idempotency_Key_Id") REFERENCES "Idempotency_Keys"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

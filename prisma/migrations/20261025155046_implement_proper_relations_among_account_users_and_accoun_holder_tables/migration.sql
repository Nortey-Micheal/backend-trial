/*
  Warnings:

  - A unique constraint covering the columns `[account_id,customer_id]` on the table `Account_Holder` will be added. If there are existing duplicate values, this will fail.

*/
-- DropForeignKey
ALTER TABLE "Customer" DROP CONSTRAINT "Customer_account_HolderId_fkey";

-- DropForeignKey
ALTER TABLE "Customer" DROP CONSTRAINT "Customer_ledger_AccountId_fkey";

-- AlterTable
ALTER TABLE "Customer" ALTER COLUMN "ledger_AccountId" DROP NOT NULL;

-- CreateIndex
CREATE INDEX "Account_Holder_customer_id_idx" ON "Account_Holder"("customer_id");

-- CreateIndex
CREATE UNIQUE INDEX "Account_Holder_account_id_customer_id_key" ON "Account_Holder"("account_id", "customer_id");

-- AddForeignKey
ALTER TABLE "Account_Holder" ADD CONSTRAINT "Account_Holder_customer_id_fkey" FOREIGN KEY ("customer_id") REFERENCES "Customer"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Customer" ADD CONSTRAINT "Customer_ledger_AccountId_fkey" FOREIGN KEY ("ledger_AccountId") REFERENCES "Ledger_Account"("id") ON DELETE SET NULL ON UPDATE CASCADE;

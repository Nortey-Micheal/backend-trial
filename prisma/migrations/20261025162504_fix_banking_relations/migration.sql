/*
  Warnings:

  - You are about to alter the column `currency_code` on the `Bank_Account` table. The data in that column could be lost. The data in that column will be cast from `Text` to `VarChar(3)`.
  - You are about to drop the column `account_HolderId` on the `Customer` table. All the data in the column will be lost.
  - A unique constraint covering the columns `[account_number]` on the table `Bank_Account` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[user_id]` on the table `Customer` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[scheduled_transfer_id,attempt_number]` on the table `Transfer_Attempt` will be added. If there are existing duplicate values, this will fail.

*/
-- DropForeignKey
ALTER TABLE "Transfer_Attempt" DROP CONSTRAINT "Transfer_Attempt_transaction_id_fkey";

-- AlterTable
ALTER TABLE "Bank_Account" ALTER COLUMN "currency_code" SET DATA TYPE VARCHAR(3);

-- AlterTable
ALTER TABLE "Customer" DROP COLUMN "account_HolderId",
ALTER COLUMN "date_of_birth" SET DATA TYPE DATE;

-- AlterTable
ALTER TABLE "Scheduled_Transfer" ALTER COLUMN "amount" SET DATA TYPE BIGINT,
ALTER COLUMN "status" SET DEFAULT 'ACTIVE';

-- AlterTable
ALTER TABLE "Transfer_Attempt" ALTER COLUMN "transaction_id" DROP NOT NULL,
ALTER COLUMN "started_at" SET DEFAULT CURRENT_TIMESTAMP;

-- CreateIndex
CREATE UNIQUE INDEX "Bank_Account_account_number_key" ON "Bank_Account"("account_number");

-- CreateIndex
CREATE UNIQUE INDEX "Customer_user_id_key" ON "Customer"("user_id");

-- CreateIndex
CREATE INDEX "Scheduled_Transfer_status_next_run_at_idx" ON "Scheduled_Transfer"("status", "next_run_at");

-- CreateIndex
CREATE INDEX "Transfer_Attempt_transaction_id_idx" ON "Transfer_Attempt"("transaction_id");

-- CreateIndex
CREATE UNIQUE INDEX "Transfer_Attempt_scheduled_transfer_id_attempt_number_key" ON "Transfer_Attempt"("scheduled_transfer_id", "attempt_number");

-- AddForeignKey
ALTER TABLE "Transfer_Attempt" ADD CONSTRAINT "Transfer_Attempt_transaction_id_fkey" FOREIGN KEY ("transaction_id") REFERENCES "Transaction"("id") ON DELETE SET NULL ON UPDATE CASCADE;

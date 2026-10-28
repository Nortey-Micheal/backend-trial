/*
  Warnings:

  - You are about to drop the column `resonse_body` on the `Idempotency_Keys` table. All the data in the column will be lost.
  - A unique constraint covering the columns `[code]` on the table `Ledger_Account` will be added. If there are existing duplicate values, this will fail.

*/
-- AlterTable
ALTER TABLE "Idempotency_Keys" DROP COLUMN "resonse_body",
ADD COLUMN     "response_body" JSONB;

-- CreateIndex
CREATE UNIQUE INDEX "Ledger_Account_code_key" ON "Ledger_Account"("code");

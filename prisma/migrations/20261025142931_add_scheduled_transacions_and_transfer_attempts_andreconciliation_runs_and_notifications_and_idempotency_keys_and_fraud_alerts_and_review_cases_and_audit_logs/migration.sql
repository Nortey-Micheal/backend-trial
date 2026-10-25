/*
  Warnings:

  - You are about to drop the column `idempotency_key` on the `Transaction` table. All the data in the column will be lost.
  - A unique constraint covering the columns `[initiated_by]` on the table `Transaction` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `idempotency_KeysId` to the `Transaction` table without a default value. This is not possible if the table is not empty.

*/
-- CreateEnum
CREATE TYPE "Fraud_Alert_Status" AS ENUM ('OPEN', 'UNDER_REVIEW', 'DISMISSED', 'CONFIRMED');

-- CreateEnum
CREATE TYPE "Severity" AS ENUM ('LOW', 'MEDIUM', 'HIGH', 'CRITICAL');

-- CreateEnum
CREATE TYPE "Review_Case_Status" AS ENUM ('OPEN', 'IN_PROGRESS', 'ESCALATED', 'RESOLVED');

-- CreateEnum
CREATE TYPE "Reconciliation_Run_Status" AS ENUM ('RUNNING', 'COMPLETED', 'FAILED', 'DISCREPANCIES_FOUND');

-- CreateEnum
CREATE TYPE "Scheduled_Transfers_Status" AS ENUM ('ACTIVE', 'PAUSED', 'COMPLETED', 'CANCELLED');

-- CreateEnum
CREATE TYPE "Frequency" AS ENUM ('ONCE', 'DAILY', 'WEEKLY', 'MONTHLY');

-- CreateEnum
CREATE TYPE "Transfer_Attempts_Status" AS ENUM ('PROCESSING', 'SUCCEEDED', 'FAILED');

-- DropIndex
DROP INDEX "Transaction_initiated_by_idempotency_key_key";

-- AlterTable
ALTER TABLE "Transaction" DROP COLUMN "idempotency_key",
ADD COLUMN     "idempotency_KeysId" TEXT NOT NULL;

-- CreateTable
CREATE TABLE "Audit_Log" (
    "id" TEXT NOT NULL,
    "actor_user_id" TEXT,
    "action" VARCHAR(100) NOT NULL,
    "entity_type" VARCHAR(100) NOT NULL,
    "entity_id" TEXT NOT NULL,
    "request_id" TEXT NOT NULL,
    "reason" TEXT NOT NULL,
    "metadata" JSONB NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Audit_Log_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Fraud_Alert" (
    "id" TEXT NOT NULL,
    "transaction_id" TEXT NOT NULL,
    "rule_code" VARCHAR(80) NOT NULL,
    "severity" "Severity" NOT NULL,
    "status" "Fraud_Alert_Status" NOT NULL,
    "details" JSONB NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "resolved_at" TIMESTAMP(3),

    CONSTRAINT "Fraud_Alert_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Review_Case" (
    "id" TEXT NOT NULL,
    "fraud_alert_id" TEXT NOT NULL,
    "assigned_to" TEXT NOT NULL,
    "status" "Review_Case_Status" NOT NULL,
    "resolution" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "resolved_at" TIMESTAMP(3),

    CONSTRAINT "Review_Case_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Idempotency_Keys" (
    "id" TEXT NOT NULL,
    "actor_user_id" TEXT NOT NULL,
    "operation" VARCHAR(100) NOT NULL,
    "key" VARCHAR(128) NOT NULL,
    "request_hash" VARCHAR(128) NOT NULL,
    "resource_id" TEXT,
    "response_status" INTEGER,
    "resonse_body" JSONB NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL,
    "expires_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Idempotency_Keys_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Notificaion" (
    "id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "type" VARCHAR(80) NOT NULL,
    "title" VARCHAR(150) NOT NULL,
    "message" TEXT NOT NULL,
    "data" JSONB,
    "read_at" TIMESTAMP(3),
    "created_at" TIMESTAMP(3),

    CONSTRAINT "Notificaion_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Reconciliation_Run" (
    "id" TEXT NOT NULL,
    "started_by" TEXT,
    "status" "Reconciliation_Run_Status" NOT NULL,
    "started_at" TIMESTAMP(3) NOT NULL,
    "completed_at" TIMESTAMP(3),
    "accounts_checked" INTEGER NOT NULL,
    "discrepancies_found" INTEGER NOT NULL,
    "summary" JSONB NOT NULL,

    CONSTRAINT "Reconciliation_Run_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Scheduled_Transfer" (
    "id" TEXT NOT NULL,
    "customer_id" TEXT NOT NULL,
    "source_account_id" TEXT NOT NULL,
    "destination_account_id" TEXT NOT NULL,
    "amount" INTEGER NOT NULL,
    "currency_code" VARCHAR(3) NOT NULL,
    "frequency" "Frequency" NOT NULL,
    "next_run_at" TIMESTAMP(3) NOT NULL,
    "end_at" TIMESTAMP(3),
    "status" "Scheduled_Transfers_Status" NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Scheduled_Transfer_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Transfer_Attempt" (
    "id" TEXT NOT NULL,
    "scheduled_transfer_id" TEXT NOT NULL,
    "transaction_id" TEXT NOT NULL,
    "attempt_number" INTEGER NOT NULL,
    "status" "Transfer_Attempts_Status" NOT NULL,
    "started_at" TIMESTAMP(3) NOT NULL,
    "finished_at" TIMESTAMP(3),
    "failure_code" VARCHAR(100),

    CONSTRAINT "Transfer_Attempt_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Idempotency_Keys_actor_user_id_operation_key_key" ON "Idempotency_Keys"("actor_user_id", "operation", "key");

-- CreateIndex
CREATE INDEX "Notificaion_user_id_created_at_idx" ON "Notificaion"("user_id", "created_at");

-- CreateIndex
CREATE UNIQUE INDEX "Transaction_initiated_by_key" ON "Transaction"("initiated_by");

-- AddForeignKey
ALTER TABLE "Audit_Log" ADD CONSTRAINT "Audit_Log_actor_user_id_fkey" FOREIGN KEY ("actor_user_id") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Fraud_Alert" ADD CONSTRAINT "Fraud_Alert_transaction_id_fkey" FOREIGN KEY ("transaction_id") REFERENCES "Transaction"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Review_Case" ADD CONSTRAINT "Review_Case_fraud_alert_id_fkey" FOREIGN KEY ("fraud_alert_id") REFERENCES "Fraud_Alert"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Review_Case" ADD CONSTRAINT "Review_Case_assigned_to_fkey" FOREIGN KEY ("assigned_to") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Idempotency_Keys" ADD CONSTRAINT "Idempotency_Keys_actor_user_id_fkey" FOREIGN KEY ("actor_user_id") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Notificaion" ADD CONSTRAINT "Notificaion_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Reconciliation_Run" ADD CONSTRAINT "Reconciliation_Run_started_by_fkey" FOREIGN KEY ("started_by") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Scheduled_Transfer" ADD CONSTRAINT "Scheduled_Transfer_customer_id_fkey" FOREIGN KEY ("customer_id") REFERENCES "Customer"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Scheduled_Transfer" ADD CONSTRAINT "Scheduled_Transfer_source_account_id_fkey" FOREIGN KEY ("source_account_id") REFERENCES "Bank_Account"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Scheduled_Transfer" ADD CONSTRAINT "Scheduled_Transfer_destination_account_id_fkey" FOREIGN KEY ("destination_account_id") REFERENCES "Bank_Account"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Transfer_Attempt" ADD CONSTRAINT "Transfer_Attempt_scheduled_transfer_id_fkey" FOREIGN KEY ("scheduled_transfer_id") REFERENCES "Scheduled_Transfer"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Transfer_Attempt" ADD CONSTRAINT "Transfer_Attempt_transaction_id_fkey" FOREIGN KEY ("transaction_id") REFERENCES "Transaction"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Transaction" ADD CONSTRAINT "Transaction_idempotency_KeysId_fkey" FOREIGN KEY ("idempotency_KeysId") REFERENCES "Idempotency_Keys"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

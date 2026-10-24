-- CreateEnum
CREATE TYPE "Account_Hold_Status" AS ENUM ('ACTIVE', 'RELEASED', 'CAPTURED', 'EXPIRED');

-- CreateEnum
CREATE TYPE "Beneficiary_Status" AS ENUM ('PENDING_VERIFICATION', 'ACTIVE', 'BLOCKED');

-- CreateEnum
CREATE TYPE "Journal_Entries_Status" AS ENUM ('DRAFT', 'POSTED', 'REVERSED');

-- CreateEnum
CREATE TYPE "Side" AS ENUM ('DEBIT', 'CREDIT');

-- CreateEnum
CREATE TYPE "Transaction_Limit_Status" AS ENUM ('ACTIVE', 'INACTIVE');

-- CreateEnum
CREATE TYPE "Fee_Rule_Status" AS ENUM ('ACIVE', 'INACTIVE');

-- CreateEnum
CREATE TYPE "Fee_Type" AS ENUM ('FIXED', 'PERCENTAGE');

-- CreateEnum
CREATE TYPE "Transaction_Status" AS ENUM ('PENDING', 'PROCESSING', 'POSTED', 'FAILED', 'CANCELLED', 'REVERSED');

-- CreateEnum
CREATE TYPE "Transaction_Type" AS ENUM ('DEPOSIT', 'WITHDRAWAL', 'TRANSFER', 'FEE', 'REVERSAL', 'ADJUSTMENT');

-- CreateTable
CREATE TABLE "Account_Balance_Projection" (
    "id" TEXT NOT NULL,
    "account_id" TEXT NOT NULL,
    "ledger_balance" INTEGER NOT NULL,
    "available_balance" INTEGER NOT NULL,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Account_Balance_Projection_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Account_Hold" (
    "id" TEXT NOT NULL,
    "account_id" TEXT NOT NULL,
    "transaction_id" TEXT NOT NULL,
    "amount" INTEGER NOT NULL,
    "status" "Account_Hold_Status" NOT NULL,
    "expired_at" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "released_at" TIMESTAMP(3),

    CONSTRAINT "Account_Hold_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Beneficiary" (
    "id" TEXT NOT NULL,
    "customer_id" TEXT NOT NULL,
    "beneficiary_name" TEXT NOT NULL,
    "bank_account_id" TEXT,
    "external_account_reference" VARCHAR(255),
    "bank_name" VARCHAR(150),
    "status" "Beneficiary_Status" NOT NULL,
    "verified_at" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Beneficiary_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Journal_Entries" (
    "id" TEXT NOT NULL,
    "transaction_id" TEXT NOT NULL,
    "journal_reference" VARCHAR(64) NOT NULL,
    "status" "Journal_Entries_Status" NOT NULL,
    "effective_at" TIMESTAMP(3) NOT NULL,
    "posted_at" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Journal_Entries_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Ledger_Postings" (
    "id" TEXT NOT NULL,
    "journal_entry_id" TEXT NOT NULL,
    "ledger_account_id" TEXT NOT NULL,
    "side" "Side" NOT NULL,
    "amount" INTEGER NOT NULL,
    "currency_code" VARCHAR(3) NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Ledger_Postings_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Transaction_Limit" (
    "id" TEXT NOT NULL,
    "account_type" "Account_Type" NOT NULL,
    "transaction_type" "Transaction_Type" NOT NULL,
    "currency_code" VARCHAR(3) NOT NULL,
    "max_single_amount" INTEGER,
    "max_daily_amount" INTEGER,
    "max_daily_count" INTEGER,
    "status" "Transaction_Limit_Status" NOT NULL,
    "created_by_id" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Transaction_Limit_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Fee_Rule" (
    "id" TEXT NOT NULL,
    "transaction_type" "Transaction_Type" NOT NULL,
    "currency_code" VARCHAR(3) NOT NULL,
    "fee_type" "Fee_Type" NOT NULL,
    "fee_value" INTEGER NOT NULL,
    "minimum_fee" INTEGER,
    "maximum_fee" INTEGER,
    "effective_from" TIMESTAMP(3) NOT NULL,
    "effective_until" TIMESTAMP(3),
    "status" "Fee_Rule_Status" NOT NULL,

    CONSTRAINT "Fee_Rule_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Transaction" (
    "id" TEXT NOT NULL,
    "reference" TEXT NOT NULL,
    "type" "Transaction_Type" NOT NULL,
    "status" "Transaction_Status" NOT NULL DEFAULT 'PENDING',
    "initiated_by" TEXT NOT NULL,
    "source_account_id" TEXT,
    "destination_account_id" TEXT,
    "amount" BIGINT NOT NULL,
    "currency_code" VARCHAR(3) NOT NULL,
    "fee_amount" BIGINT NOT NULL DEFAULT 0,
    "description" TEXT,
    "idempotency_key" TEXT NOT NULL,
    "failure_code" TEXT,
    "failure_message" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "completed_at" TIMESTAMP(3),
    "reversed_at" TIMESTAMP(3),

    CONSTRAINT "Transaction_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Journal_Entries_journal_reference_key" ON "Journal_Entries"("journal_reference");

-- CreateIndex
CREATE UNIQUE INDEX "Transaction_reference_key" ON "Transaction"("reference");

-- CreateIndex
CREATE INDEX "Transaction_source_account_id_created_at_idx" ON "Transaction"("source_account_id", "created_at");

-- CreateIndex
CREATE INDEX "Transaction_destination_account_id_created_at_idx" ON "Transaction"("destination_account_id", "created_at");

-- CreateIndex
CREATE INDEX "Transaction_status_created_at_idx" ON "Transaction"("status", "created_at");

-- CreateIndex
CREATE INDEX "Transaction_type_created_at_idx" ON "Transaction"("type", "created_at");

-- CreateIndex
CREATE UNIQUE INDEX "Transaction_initiated_by_idempotency_key_key" ON "Transaction"("initiated_by", "idempotency_key");

-- AddForeignKey
ALTER TABLE "Account_Balance_Projection" ADD CONSTRAINT "Account_Balance_Projection_account_id_fkey" FOREIGN KEY ("account_id") REFERENCES "Bank_Account"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Account_Hold" ADD CONSTRAINT "Account_Hold_account_id_fkey" FOREIGN KEY ("account_id") REFERENCES "Bank_Account"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Account_Hold" ADD CONSTRAINT "Account_Hold_transaction_id_fkey" FOREIGN KEY ("transaction_id") REFERENCES "Transaction"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Beneficiary" ADD CONSTRAINT "Beneficiary_customer_id_fkey" FOREIGN KEY ("customer_id") REFERENCES "Customer"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Journal_Entries" ADD CONSTRAINT "Journal_Entries_transaction_id_fkey" FOREIGN KEY ("transaction_id") REFERENCES "Transaction"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Ledger_Postings" ADD CONSTRAINT "Ledger_Postings_journal_entry_id_fkey" FOREIGN KEY ("journal_entry_id") REFERENCES "Journal_Entries"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Ledger_Postings" ADD CONSTRAINT "Ledger_Postings_ledger_account_id_fkey" FOREIGN KEY ("ledger_account_id") REFERENCES "Ledger_Account"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Transaction_Limit" ADD CONSTRAINT "Transaction_Limit_created_by_id_fkey" FOREIGN KEY ("created_by_id") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Transaction" ADD CONSTRAINT "Transaction_source_account_id_fkey" FOREIGN KEY ("source_account_id") REFERENCES "Bank_Account"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Transaction" ADD CONSTRAINT "Transaction_destination_account_id_fkey" FOREIGN KEY ("destination_account_id") REFERENCES "Bank_Account"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

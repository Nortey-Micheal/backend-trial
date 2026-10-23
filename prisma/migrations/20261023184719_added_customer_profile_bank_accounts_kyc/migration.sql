/*
  Warnings:

  - You are about to drop the column `name` on the `User` table. All the data in the column will be lost.

*/
-- CreateEnum
CREATE TYPE "Account_Holder_Relationship" AS ENUM ('OWNER', 'JOINT_OWNER', 'AUTHORIZED_SIGNATORY');

-- CreateEnum
CREATE TYPE "Account_Status" AS ENUM ('PENDING_VERIFICATION', 'ACTIVE', 'FROZEN', 'RESTRICTED', 'CLOSED');

-- CreateEnum
CREATE TYPE "AccountType" AS ENUM ('SAVINGS', 'CURRENT');

-- CreateEnum
CREATE TYPE "KYC_Status" AS ENUM ('NOT_STARTED', 'PENDING_VERIFICATION', 'UNDER_REVIEW', 'VERIFIED', 'REJECTED', 'MORE_INFO_REQUIRED');

-- CreateEnum
CREATE TYPE "KYC_DOC_Status" AS ENUM ('SUBMITTED', 'ACCEPTED', 'REJECTED');

-- AlterTable
ALTER TABLE "User" DROP COLUMN "name";

-- CreateTable
CREATE TABLE "Bank_Account" (
    "id" TEXT NOT NULL,
    "account_number" TEXT NOT NULL,
    "account" "AccountType" NOT NULL,
    "currency_code" TEXT NOT NULL,
    "status" "Account_Status" NOT NULL,
    "opened_at" TIMESTAMP(3),
    "closed_at" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Bank_Account_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Account_Holder" (
    "id" TEXT NOT NULL,
    "account_id" TEXT NOT NULL,
    "customer_id" TEXT NOT NULL,
    "relationship_type" "Account_Holder_Relationship" NOT NULL,
    "can_view" BOOLEAN NOT NULL DEFAULT true,
    "can_transact" BOOLEAN NOT NULL DEFAULT true,
    "started_at" TIMESTAMP(3) NOT NULL,
    "ended_at" TIMESTAMP(3),

    CONSTRAINT "Account_Holder_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Customer" (
    "id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "first_name" TEXT NOT NULL,
    "middle_name" TEXT,
    "last_name" TEXT NOT NULL,
    "date_of_birth" TIMESTAMP(3) NOT NULL,
    "address_line_1" TEXT NOT NULL,
    "address_line_2" TEXT,
    "city" TEXT NOT NULL,
    "region" TEXT,
    "country_code" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "account_HolderId" TEXT NOT NULL,

    CONSTRAINT "Customer_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Kyc_Case" (
    "id" TEXT NOT NULL,
    "customer_id" TEXT NOT NULL,
    "status" "KYC_Status" NOT NULL DEFAULT 'NOT_STARTED',
    "submitted_at" TIMESTAMP(3),
    "reviewed_by" TEXT NOT NULL,

    CONSTRAINT "Kyc_Case_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Kyc_Document" (
    "id" TEXT NOT NULL,
    "kyc_case_id" TEXT NOT NULL,
    "document_type" TEXT NOT NULL,
    "storage_key" TEXT NOT NULL,
    "document_reference_hash" TEXT NOT NULL,
    "status" "KYC_DOC_Status" NOT NULL,
    "uploaded_at" TIMESTAMP(3) NOT NULL,
    "reviewed_at" TIMESTAMP(3),

    CONSTRAINT "Kyc_Document_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Session" (
    "id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "device_label" TEXT,
    "ip_address" TEXT,
    "user_agent" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "last_seen_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "expires_at" TIMESTAMP(3) NOT NULL,
    "revoked_at" TIMESTAMP(3),

    CONSTRAINT "Session_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "refresh_token" (
    "id" TEXT NOT NULL,
    "session_id" TEXT NOT NULL,
    "token_hash" TEXT NOT NULL,
    "family_id" TEXT NOT NULL,
    "expires_at" TIMESTAMP(3) NOT NULL,
    "used_at" TIMESTAMP(3),
    "revoked_at" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "refresh_token_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "Session_user_id_idx" ON "Session"("user_id");

-- CreateIndex
CREATE INDEX "Session_expires_at_idx" ON "Session"("expires_at");

-- CreateIndex
CREATE UNIQUE INDEX "refresh_token_token_hash_key" ON "refresh_token"("token_hash");

-- CreateIndex
CREATE INDEX "refresh_token_family_id_idx" ON "refresh_token"("family_id");

-- CreateIndex
CREATE INDEX "refresh_token_session_id_idx" ON "refresh_token"("session_id");

-- CreateIndex
CREATE INDEX "refresh_token_expires_at_idx" ON "refresh_token"("expires_at");

-- AddForeignKey
ALTER TABLE "Account_Holder" ADD CONSTRAINT "Account_Holder_account_id_fkey" FOREIGN KEY ("account_id") REFERENCES "Bank_Account"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Customer" ADD CONSTRAINT "Customer_account_HolderId_fkey" FOREIGN KEY ("account_HolderId") REFERENCES "Account_Holder"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Kyc_Case" ADD CONSTRAINT "Kyc_Case_reviewed_by_fkey" FOREIGN KEY ("reviewed_by") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Kyc_Document" ADD CONSTRAINT "Kyc_Document_kyc_case_id_fkey" FOREIGN KEY ("kyc_case_id") REFERENCES "Kyc_Case"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Session" ADD CONSTRAINT "Session_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "refresh_token" ADD CONSTRAINT "refresh_token_session_id_fkey" FOREIGN KEY ("session_id") REFERENCES "Session"("id") ON DELETE CASCADE ON UPDATE CASCADE;

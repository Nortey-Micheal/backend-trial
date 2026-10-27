-- AlterTable
ALTER TABLE "User" ADD COLUMN     "verification_code" TEXT,
ADD COLUMN     "verification_code_expires" TIMESTAMP(3);

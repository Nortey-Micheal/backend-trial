/*
  Warnings:

  - A unique constraint covering the columns `[email_normalized]` on the table `User` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[phone_normalized]` on the table `User` will be added. If there are existing duplicate values, this will fail.

*/
-- CreateEnum
CREATE TYPE "Status" AS ENUM ('PENDING_VERIFICATION', 'ACTIVE', 'LOCKED', 'DEACTIVATED');

-- DropIndex
DROP INDEX "User_email_key";

-- AlterTable
ALTER TABLE "User" ADD COLUMN     "email_normalized" TEXT,
ADD COLUMN     "email_verified_at" TIMESTAMP(3),
ADD COLUMN     "last_login_at" TIMESTAMP(3),
ADD COLUMN     "phone" TEXT,
ADD COLUMN     "phone_normalized" TEXT,
ADD COLUMN     "phone_verified_at" TIMESTAMP(3),
ADD COLUMN     "status" "Status" NOT NULL DEFAULT 'PENDING_VERIFICATION',
ALTER COLUMN "email" DROP NOT NULL;

-- CreateTable
CREATE TABLE "Roles" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Roles_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "User_Roles" (
    "user_id" TEXT NOT NULL,
    "role_id" TEXT NOT NULL,
    "assigned_by" TEXT,
    "assigned_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "User_Roles_pkey" PRIMARY KEY ("user_id","role_id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Roles_name_key" ON "Roles"("name");

-- CreateIndex
CREATE UNIQUE INDEX "User_email_normalized_key" ON "User"("email_normalized");

-- CreateIndex
CREATE UNIQUE INDEX "User_phone_normalized_key" ON "User"("phone_normalized");

-- AddForeignKey
ALTER TABLE "User_Roles" ADD CONSTRAINT "User_Roles_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "User_Roles" ADD CONSTRAINT "User_Roles_role_id_fkey" FOREIGN KEY ("role_id") REFERENCES "Roles"("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "User"
ADD CONSTRAINT "user_requires_login_identifier"
CHECK (
  "email_normalized" IS NOT NULL
  OR "phone_normalized" IS NOT NULL
);
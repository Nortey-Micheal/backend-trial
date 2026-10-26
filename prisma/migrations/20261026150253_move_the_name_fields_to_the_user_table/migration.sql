/*
  Warnings:

  - You are about to drop the column `first_name` on the `Customer` table. All the data in the column will be lost.
  - You are about to drop the column `last_name` on the `Customer` table. All the data in the column will be lost.
  - You are about to drop the column `middle_name` on the `Customer` table. All the data in the column will be lost.
  - Added the required column `first_name` to the `User` table without a default value. This is not possible if the table is not empty.
  - Added the required column `last_name` to the `User` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "Customer" DROP COLUMN "first_name",
DROP COLUMN "last_name",
DROP COLUMN "middle_name";

-- AlterTable
ALTER TABLE "User" ADD COLUMN     "first_name" TEXT NOT NULL,
ADD COLUMN     "last_name" TEXT NOT NULL,
ADD COLUMN     "middle_name" TEXT;

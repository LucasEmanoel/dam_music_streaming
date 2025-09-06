/*
  Warnings:

  - You are about to drop the column `genre_deezer_id` on the `album` table. All the data in the column will be lost.
  - You are about to alter the column `id_deezer` on the `album` table. The data in that column could be lost. The data in that column will be cast from `BigInt` to `Integer`.
  - You are about to alter the column `id_deezer` on the `artist` table. The data in that column could be lost. The data in that column will be cast from `BigInt` to `Integer`.
  - You are about to alter the column `id_deezer` on the `genre` table. The data in that column could be lost. The data in that column will be cast from `BigInt` to `Integer`.
  - You are about to alter the column `id_deezer` on the `song` table. The data in that column could be lost. The data in that column will be cast from `BigInt` to `Integer`.

*/
-- AlterTable
ALTER TABLE "public"."album" DROP COLUMN "genre_deezer_id",
ALTER COLUMN "id_deezer" SET DATA TYPE INTEGER;

-- AlterTable
ALTER TABLE "public"."artist" ALTER COLUMN "id_deezer" SET DATA TYPE INTEGER;

-- AlterTable
ALTER TABLE "public"."genre" ALTER COLUMN "id_deezer" SET DATA TYPE INTEGER;

-- AlterTable
ALTER TABLE "public"."song" ALTER COLUMN "id_deezer" SET DATA TYPE INTEGER;

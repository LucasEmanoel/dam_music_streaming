-- AlterTable
ALTER TABLE "public"."album" ALTER COLUMN "id_deezer" SET DATA TYPE BIGINT,
ALTER COLUMN "genre_deezer_id" SET DATA TYPE BIGINT;

-- AlterTable
ALTER TABLE "public"."artist" ALTER COLUMN "id_deezer" SET DATA TYPE BIGINT;

-- AlterTable
ALTER TABLE "public"."genre" ALTER COLUMN "id_deezer" SET DATA TYPE BIGINT;

-- AlterTable
ALTER TABLE "public"."song" ALTER COLUMN "id_deezer" SET DATA TYPE BIGINT;

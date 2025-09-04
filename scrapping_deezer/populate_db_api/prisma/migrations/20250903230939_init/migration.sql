-- CreateTable
CREATE TABLE "public"."Genre" (
    "id" SERIAL NOT NULL,
    "idDeezer" INTEGER NOT NULL,
    "name" TEXT NOT NULL,

    CONSTRAINT "Genre_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Artist" (
    "id" SERIAL NOT NULL,
    "idDeezer" INTEGER NOT NULL,
    "name" TEXT NOT NULL,
    "picture" TEXT NOT NULL,
    "pictureSmall" TEXT NOT NULL,
    "pictureMedium" TEXT NOT NULL,
    "pictureBig" TEXT NOT NULL,
    "pictureXl" TEXT NOT NULL,
    "radio" BOOLEAN NOT NULL,
    "tracklist" TEXT NOT NULL,
    "type" TEXT NOT NULL,
    "genreId" INTEGER NOT NULL,

    CONSTRAINT "Artist_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Album" (
    "id" SERIAL NOT NULL,
    "idDeezer" INTEGER NOT NULL,
    "title" TEXT NOT NULL,
    "link" TEXT NOT NULL,
    "cover" TEXT NOT NULL,
    "coverSmall" TEXT NOT NULL,
    "coverMedium" TEXT NOT NULL,
    "coverBig" TEXT NOT NULL,
    "coverXl" TEXT NOT NULL,
    "md5Image" TEXT NOT NULL,
    "genreDeezerId" INTEGER NOT NULL,
    "fans" INTEGER NOT NULL,
    "releasedDate" TEXT NOT NULL,
    "recordType" TEXT NOT NULL,
    "tracklist" TEXT NOT NULL,
    "explicitLyrics" BOOLEAN NOT NULL,
    "type" TEXT NOT NULL,
    "genreId" INTEGER NOT NULL,
    "artistId" INTEGER NOT NULL,

    CONSTRAINT "Album_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Song" (
    "id" SERIAL NOT NULL,
    "idDeezer" INTEGER NOT NULL,
    "readable" BOOLEAN NOT NULL,
    "title" TEXT NOT NULL,
    "titleShort" TEXT NOT NULL,
    "titleVersion" TEXT NOT NULL,
    "isrc" TEXT NOT NULL,
    "link" TEXT NOT NULL,
    "duration" INTEGER NOT NULL,
    "trackPosition" INTEGER NOT NULL,
    "diskNumber" INTEGER NOT NULL,
    "rank" INTEGER NOT NULL,
    "explicitLyrics" BOOLEAN NOT NULL,
    "explicitContentLyrics" INTEGER NOT NULL,
    "explicitContentCover" INTEGER NOT NULL,
    "preview" TEXT NOT NULL,
    "md5Image" TEXT NOT NULL,
    "type" TEXT NOT NULL,
    "downloadUrl" TEXT NOT NULL,
    "genreId" INTEGER NOT NULL,
    "artistId" INTEGER NOT NULL,
    "albumId" INTEGER NOT NULL,

    CONSTRAINT "Song_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "public"."Artist" ADD CONSTRAINT "Artist_genreId_fkey" FOREIGN KEY ("genreId") REFERENCES "public"."Genre"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Album" ADD CONSTRAINT "Album_genreId_fkey" FOREIGN KEY ("genreId") REFERENCES "public"."Genre"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Album" ADD CONSTRAINT "Album_artistId_fkey" FOREIGN KEY ("artistId") REFERENCES "public"."Artist"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Song" ADD CONSTRAINT "Song_genreId_fkey" FOREIGN KEY ("genreId") REFERENCES "public"."Genre"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Song" ADD CONSTRAINT "Song_artistId_fkey" FOREIGN KEY ("artistId") REFERENCES "public"."Artist"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Song" ADD CONSTRAINT "Song_albumId_fkey" FOREIGN KEY ("albumId") REFERENCES "public"."Album"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

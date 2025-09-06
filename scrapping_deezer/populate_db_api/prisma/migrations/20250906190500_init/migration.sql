-- CreateTable
CREATE TABLE "public"."genre" (
    "id" BIGSERIAL NOT NULL,
    "id_deezer" INTEGER NOT NULL,
    "name" TEXT NOT NULL,

    CONSTRAINT "genre_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."artist" (
    "id" BIGSERIAL NOT NULL,
    "id_deezer" INTEGER NOT NULL,
    "name" TEXT NOT NULL,
    "picture" TEXT NOT NULL,
    "picture_small" TEXT NOT NULL,
    "picture_medium" TEXT NOT NULL,
    "picture_big" TEXT NOT NULL,
    "picture_xl" TEXT NOT NULL,
    "radio" BOOLEAN NOT NULL,
    "tracklist" TEXT NOT NULL,
    "type" TEXT NOT NULL,
    "genre_id" BIGINT NOT NULL,

    CONSTRAINT "artist_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."album" (
    "id" BIGSERIAL NOT NULL,
    "id_deezer" INTEGER NOT NULL,
    "title" TEXT NOT NULL,
    "link" TEXT NOT NULL,
    "cover" TEXT NOT NULL,
    "cover_small" TEXT NOT NULL,
    "cover_medium" TEXT NOT NULL,
    "cover_big" TEXT NOT NULL,
    "cover_xl" TEXT NOT NULL,
    "md5_image" TEXT NOT NULL,
    "genre_deezer_id" INTEGER NOT NULL,
    "fans" INTEGER NOT NULL,
    "release_date" TEXT NOT NULL,
    "record_type" TEXT NOT NULL,
    "tracklist" TEXT NOT NULL,
    "explicit_lyrics" BOOLEAN NOT NULL,
    "type" TEXT NOT NULL,
    "genre_id" BIGINT NOT NULL,
    "artist_id" BIGINT NOT NULL,

    CONSTRAINT "album_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."song" (
    "id" BIGSERIAL NOT NULL,
    "id_deezer" INTEGER NOT NULL,
    "readable" BOOLEAN NOT NULL,
    "title" TEXT NOT NULL,
    "title_short" TEXT NOT NULL,
    "title_version" TEXT NOT NULL,
    "isrc" TEXT NOT NULL,
    "link" TEXT NOT NULL,
    "duration" INTEGER NOT NULL,
    "track_position" INTEGER NOT NULL,
    "disk_number" INTEGER NOT NULL,
    "rank" INTEGER NOT NULL,
    "explicit_lyrics" BOOLEAN NOT NULL,
    "explicit_content_lyrics" INTEGER NOT NULL,
    "explicit_content_cover" INTEGER NOT NULL,
    "preview" TEXT NOT NULL,
    "md5_image" TEXT NOT NULL,
    "type" TEXT NOT NULL,
    "download_url" TEXT NOT NULL,
    "genre_id" BIGINT NOT NULL,
    "artist_id" BIGINT NOT NULL,
    "album_id" BIGINT NOT NULL,

    CONSTRAINT "song_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "public"."artist" ADD CONSTRAINT "artist_genre_id_fkey" FOREIGN KEY ("genre_id") REFERENCES "public"."genre"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."album" ADD CONSTRAINT "album_genre_id_fkey" FOREIGN KEY ("genre_id") REFERENCES "public"."genre"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."album" ADD CONSTRAINT "album_artist_id_fkey" FOREIGN KEY ("artist_id") REFERENCES "public"."artist"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."song" ADD CONSTRAINT "song_genre_id_fkey" FOREIGN KEY ("genre_id") REFERENCES "public"."genre"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."song" ADD CONSTRAINT "song_artist_id_fkey" FOREIGN KEY ("artist_id") REFERENCES "public"."artist"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."song" ADD CONSTRAINT "song_album_id_fkey" FOREIGN KEY ("album_id") REFERENCES "public"."album"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

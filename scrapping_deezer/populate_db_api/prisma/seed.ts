import { PrismaClient } from '../generated/prisma';
const prisma = new PrismaClient();

import fs from 'fs';
import path from 'path';

async function seed() {
    console.log('Database started seeded');

    const genres = [
        {
            name: 'pop',
            idDeezer:132
        },
        {
            name: 'rock',
            idDeezer:152
        },
        {
            name: 'rAndb',
            idDeezer:165
        },
        {
            name: 'mpb',
            idDeezer:78
        },
        {
            name: 'alt',
            idDeezer:85
        },
        {
            name: 'rAndb',
            idDeezer:116
        }
    ];

    for (const genre of genres) { // <-- Use for...of aqui
        const __dirname = path.resolve();
        const filePath = path.join(__dirname, `../${genre.name}_final.json`);
        const file = fs.readFileSync(filePath, "utf-8");
        const genreData = JSON.parse(file);

        console.log('Criando Gênero');
        const createdGenre = await prisma.genre.create({
            data: {
                name: genre.name,
                idDeezer: genre.idDeezer
            }
        });

        console.log('Gênero criado', createdGenre.id);

        for (const artist of genreData) { // <-- E aqui
            console.log('Criando Artista');
            const createdArtist = await prisma.artist.create({
                data: {
                    idDeezer: artist['id'],
                    name: artist['name'],
                    picture: artist['picture'],
                    pictureSmall: artist['picture_small'],
                    pictureMedium: artist['picture_medium'],
                    pictureBig: artist['picture_big'],
                    pictureXl: artist['picture_xl'],
                    radio: artist['radio'],
                    tracklist: artist['tracklist'],
                    type: artist['type'],
                    genre: {
                        connect: {
                            id: createdGenre.id
                        }
                    }
                }
            });
            console.log('Artista criado', createdArtist.id);

            for (const album of artist.albums) { // <-- E aqui
                console.log('Criando Album');
                const createdAlbum = await prisma.album.create({
                    data: {
                        idDeezer: album['id'],
                        title: album['title'],
                        link: album['link'],
                        cover: album['cover'],
                        coverSmall: album['cover_small'],
                        coverMedium: album['cover_medium'],
                        coverBig: album['cover_big'],
                        coverXl: album['cover_xl'],
                        md5Image: album['md5_image'],
                        genreDeezerId: album['genre_id'],
                        fans: album['fans'],
                        releasedDate: album['release_date'],
                        recordType: album['record_type'],
                        tracklist: album['tracklist'],
                        explicitLyrics: album['explicit_lyrics'],
                        type: album['type'],
                        genre: {
                            connect: {
                                id: createdGenre.id
                            }
                        },
                        artist: {
                            connect: {
                                id: createdArtist.id
                            }
                        }
                    }
                });
                console.log('Album criado', createdAlbum.id);

                for (const track of album.tracks) { // <-- E por fim, aqui também
                    console.log('Criando Musica');
                    const createdSong = await prisma.song.create({
                        data: {
                            idDeezer: track['id'],
                            readable: track['readable'],
                            title: track['title'],
                            titleShort: track['title_short'],
                            titleVersion: track['title_version'],
                            isrc: track['isrc'],
                            link: track['link'],
                            duration: track['duration'],
                            trackPosition: track['track_position'],
                            diskNumber: track['disk_number'],
                            rank: track['rank'],
                            explicitLyrics: track['explicit_lyrics'],
                            explicitContentLyrics: track['explicit_content_lyrics'],
                            explicitContentCover: track['explicit_content_cover'],
                            preview: track['preview'],
                            md5Image: track['md5_image'],
                            type: track['type'],
                            downloadUrl: `https://dam-harmony.s3.us-east-1.amazonaws.com/${track['id']}.mp3`,
                            genre: {
                                connect: {
                                    id: createdGenre.id
                                }
                            },
                            artist: {
                                connect: {
                                    id: createdArtist.id
                                }
                            },
                            album: {
                                connect: {
                                    id: createdAlbum.id
                                }
                            }
                        }
                    });
                    console.log('Musica criada', createdSong.id);
                }
            }
        }
    }

    await prisma.$disconnect();
}

seed().catch(e => {
    console.error(e);
    prisma.$disconnect();
    process.exit(1);
});
import fs from 'fs';

const genres = [
    152, //rock
    165, //R&B
    116, //Rap/ Hip hop
    132, //Pop
    78, //MPB
    85 //Alternativo
]

const genreLabel = {
    152: 'rock',
    165: 'rAndb',
    116: 'rap',
    132: 'pop',
    78: 'mpb',
    85: 'alt'
}

const sleep = (ms) => new Promise(resolve => setTimeout(resolve, ms));

async function main(){
    const genre = 85;
    const file = fs.readFileSync(`${genre}_artists_albuns.json`, "utf-8");
    const artistsAlbums = JSON.parse(file);

    const data = [];
    for (let index = 0; index < artistsAlbums.length; index++) {
        const {artist, albums} = artistsAlbums[index];
    
        let albumsWithMusic = [];
        for (let indexJ = 0; indexJ < albums.length; indexJ++) {
            const album = albums[indexJ];
            const albumId = album.id;

            const response = await fetch(`https://api.deezer.com/album/${albumId}/tracks`);
            const tracks = await response.json();
            albumsWithMusic.push({
                ...album,
                tracks:[
                    ...tracks.data
                ]
            })

            //limite de 10 requisições por segundo da api do deezer
            if ((indexJ + 1) % 5 === 0) {
                console.log(`THREAD SLEEPED - artist ${artist.name} - albumIdx ${indexJ}`)
                await sleep(2000);
            }
        }

        data.push({
            ...artist,
            albums: [
                ...albumsWithMusic
            ]
        })

        // if ((index + 1) % 10 === 0) {
        //     await sleep(2000);
        // }
    }  
    
    const style = genreLabel[genre];
    fs.writeFileSync(`${style}.json`, JSON.stringify(data), "utf-8");   
}
await main();
import fs from 'fs';

const sleep = (ms) => new Promise(resolve => setTimeout(resolve, ms));

async function main(){
    const genre = 85;
    const file = fs.readFileSync(`${genre}.json`, "utf-8");
    const artists= JSON.parse(file);

    const data = [];
    for (let index = 0; index < artists.length; index++) {
        const artist = artists[index];
        const artistId = artist.id;
    
        const response = await fetch(`https://api.deezer.com/artist/${artistId}/albums`);
        const albums = await response.json();
        albumsWithMusic.push({
            artist,
            albums: albums.data
        })

        //limite de 10 requisições por segundo da api do deezer
        if ((indexJ + 1) % 10 === 0) {
            console.log(`THREAD SLEEPED`)
            await sleep(2000);
        }
    }  
    
    fs.writeFileSync(`${genre}_artists_albuns.json`, JSON.stringify(data), "utf-8");   
}
await main();
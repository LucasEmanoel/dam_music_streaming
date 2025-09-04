import fs from 'fs';

function main(){
    const genre = 'rap';
    const file = fs.readFileSync(`${genre}.json`, "utf-8");
    const genreData = JSON.parse(file);

    const newArtists = [];
    for(let indexI in genreData){
        if(indexI == 10) break;

        const artist = genreData[indexI];
        const albums = artist.albums;
        const newAlbums = [];

        for(let indexJ in albums){
            if(indexJ == 6) break;
            
            const album = albums[indexJ];
            newAlbums.push(album);
        }

        const newArtist = {
            ...artist,
            albums: newAlbums
        }

        newArtists.push(newArtist);
    }

    fs.writeFileSync(`${genre}_final.json`, JSON.stringify(newArtists), "utf-8");   
}

main();
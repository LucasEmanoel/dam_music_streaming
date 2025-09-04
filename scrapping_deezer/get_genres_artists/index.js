import fs from 'fs';

const genres = [
    152, //rock
    165, //R&B
    116, //Rap/ Hip hop
    132, //Pop
    78, //MPB
    85 //Alternativo
]

async function main(){
    genres.forEach(async genre=>{
        const response = await fetch(`https://api.deezer.com/genre/${genre}/artists`);
        const artists = await response.json();
        fs.writeFileSync(`${genre}.json`, JSON.stringify(artists), "utf-8");        
    })
}

await main();
import fs from 'fs';
import {exec} from 'child_process';

function baixarMusica(artist, album, title, id){
    return new Promise((resolve, reject) => {
        const removerAcentos = (str) =>
            str.normalize("NFD").replace(/[\u0300-\u036f]/g, "");

        const query = `${title} ${artist}`;
        const artistNormalizado = removerAcentos(artist).replace(/\s+/g, "_");
        const albumNormalizado = removerAcentos(album).replace(/\s+/g, "_");
        const output = `songs/${artistNormalizado}/${albumNormalizado}/${id}.mp3`;

        // yt-dlp faz a busca no YouTube automaticamente
        const cmd = `yt-dlp.exe -x --audio-format mp3 -o "${output}" "ytsearch1:${query}"`;

        console.log(`🔎 Baixando: ${query}`);
        exec(cmd, (err, stdout, stderr) => {
        if (err) {
            console.error(`❌ Erro ao baixar ${query}:`,stderr);
            resolve(false);
        } else {
            console.log(`✅ Baixado: ${query}`);
            resolve(true);
        }
        });
    });
}

async function main(){
    const genre = 'rock';
    const file = fs.readFileSync(`${genre}_final.json`, "utf-8");
    const genreData = JSON.parse(file);

    for(let artist of genreData){
        const albums = artist.albums;

        for(let album of albums){
            const tracks = album.tracks;

            for(let track of tracks){
                await baixarMusica(artist.name, album.title, track.title, track.id);
            }
        }
    }
}

await main();
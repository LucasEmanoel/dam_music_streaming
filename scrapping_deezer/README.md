# Como fazer o scrapping:

## Requisitos:
- Nodejs (https://www.nodejs.tech/pt-br/download)

1. Buscar o id do gênero que fará o scrapping:
Isso pode ser feito através da rota https://api.deezer.com/genre onde trará todos os gêneros disponíveis no deezer. Um exemplo com objetos reais pode ser encontrada em https://developers.deezer.com/api/explorer.

2. Buscar os artistas do gênero:
Para isso utilize o get_genres_artists/index.js. Esse script possui um array de alguns gêneros de exemplo, modificar com os gêneros que deseja fazer o scrapping.
Para executar o script:
```
cd get_genres_artists
node index.js
```

Observação: Dificilmente cairá nesse caso, mas o deezer tem um limite de 10 chamadas por segundo, portanto em teoria o array máximo desse arquivo deverá ter no maximo 10 itens por execução.

3. Buscar os albums dos artistas
Para isso utilize o get_artist_albums/index.js. Modifique a variável gênero (genre) no script com o id do gênero do deezer.
Para executar o script:
```
cd get_artist_albums
node index.js
```

4. Buscar os albums dos artistas:
Para isso utilize o get_artist_albums/index.js. Modifique a variável gênero (genre) no script com o id do gênero do deezer.
Para executar o script:
```
cd get_artist_albums
node index.js
```

5. Buscar as músicas dos albums:
Para isso utilize o get_tracks_album/get_tracks_album.js. Modifique a variável gênero (genre) no script com o id do gênero do deezer e map de genreLabel para retornar o nome correto do gênero ao fim. 
Para executar o script:
```
cd get_tracks_album
node get_tracks_album.js
```

6. Filtrar os resultados (opcional)
Como a próxima etapa demora bastante, pode ser necessário reduzir o tamanho do json recuperado. 
Tamanho dos retornos após o scraping:
1 gêneros
50 artistas
25 albums
X músicas por album

Tamanho recomendados:
1 gêneros
10 artistas
6 albums
X músicas por album

Para executar o script:
```
cd filter_minimum_qtd_songs
node filter_genres.js
```

6. Baixar as músicas:
Para isso utilize o get_tracks_album/get_tracks_album.js. Modifique a variável gênero (genre) no script com o nome do gênero do arquivo .json.
Para executar o script:
```
node download_script.js
```

7. Upar os arquivos baixados no S3
Usar interface do aws console

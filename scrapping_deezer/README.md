# Como fazer o scrapping:

## Requisitos:
- Nodejs (https://www.nodejs.tech/pt-br/download)
- PostgresSql

## Etapas:
1. Buscar o id do gênero que fará o scrapping:<br/>
Isso pode ser feito através da rota https://api.deezer.com/genre onde trará todos os gêneros disponíveis no deezer. Um exemplo com objetos reais pode ser encontrada em https://developers.deezer.com/api/explorer.

2. Buscar os artistas do gênero:<br/>
Para isso utilize o get_genres_artists/index.js. Esse script possui um array de alguns gêneros de exemplo, modificar com os gêneros que deseja fazer o scrapping.
Para executar o script:
```
cd get_genres_artists
node index.js
```

Observação: Dificilmente cairá nesse caso, mas o deezer tem um limite de 10 chamadas por segundo, portanto em teoria o array máximo desse arquivo deverá ter no maximo 10 itens por execução.

3. Buscar os albums dos artistas<br/>
Para isso utilize o get_artist_albums/index.js. Modifique a variável gênero (genre) no script com o id do gênero do deezer.
Para executar o script:
```
cd get_artist_albums
node index.js
```

4. Buscar os albums dos artistas:<br/>
Para isso utilize o get_artist_albums/index.js. Modifique a variável gênero (genre) no script com o id do gênero do deezer.
Para executar o script:
```
cd get_artist_albums
node index.js
```

5. Buscar as músicas dos albums:<br/>
Para isso utilize o get_tracks_album/get_tracks_album.js. Modifique a variável gênero (genre) no script com o id do gênero do deezer e map de genreLabel para retornar o nome correto do gênero ao fim. 
Para executar o script:
```
cd get_tracks_album
node get_tracks_album.js
```

6. Filtrar os resultados (opcional)<br/>
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

7. Baixar as músicas:<br/>
Para isso utilize o get_tracks_album/get_tracks_album.js. Modifique a variável gênero (genre) no script com o nome do gênero do arquivo .json.
Para executar o script:
```
node download_script.js
```

9. Upar os arquivos baixados no S3<br/>
Usar interface do aws console

10. Atualizar o banco de dados:<br/>
Para isso utilize o backend node populate_db_api.

Inicialização:
```
cd populate_db_api
npm install
```

Altere a url do banco em .env:
```
DATABASE_URL="postgres://postgres:1234@localhost:5432/harmony_test"
```

Gere o cliente do prisma:
```
npx prisma generate
```

Rode o seed para popular o banco:
```
npm run seed
```

11. Gerar o dump do banco de dados: <br/>
Por fim, para gerar o dump e atualizar o data.sql do backend, rode o seguinte comando do terminal:
```
pg_dump --inserts -u postgres -d harmony_test > output.sql
```

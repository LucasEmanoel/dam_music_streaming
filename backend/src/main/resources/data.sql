-- Usuários (sem alteração)
-- Inserindo usuários com senhas criptografadas (BCrypt)
-- VERSÃO CORRIGIDA (SEM ID MANUAL)
INSERT INTO usuario (username, email, password, role) VALUES
('carla_santos', 'carla.santos@example.com', '$2a$10$8VjnmPRt66YC/MpNezspYev/yo7T5z0DU52i00dCb9RaD87HH5f8i', 'USER'),
('bruno_costa', 'bruno.costa@example.com', '$2a$10$8VjnmPRt66YC/MpNezspYev/yo7T5z0DU52i00dCb9RaD87HH5f8i', 'USER'),
('admin', 'admin@example.com', '$2a$10$8VjnmPRt66YC/MpNezspYev/yo7T5z0DU52i00dCb9RaD87HH5f8i', 'ADMIN');

INSERT INTO artist (name, picture_url) VALUES
('Queen', 'https://e-cdns-images.dzcdn.net/images/artist/b179e63df52f874d6b5c0350a417e252/500x500-000000-80-0-0.jpg'),
('Daft Punk', 'https://e-cdns-images.dzcdn.net/images/artist/f2bc007e9133c946ac3c3907ddc5d2ea/500x500-000000-80-0-0.jpg'),
('Arctic Monkeys', 'https://e-cdns-images.dzcdn.net/images/artist/7783a6c71a337f6a72f0939a3f25368a/500x500-000000-80-0-0.jpg'),
('Legião Urbana', 'https://e-cdns-images.dzcdn.net/images/artist/235e451478546b2b2915e8361b3699c3/500x500-000000-80-0-0.jpg');

-- Álbuns (com a coluna 'duration' corrigida para nanossegundos)
INSERT INTO album (title, url_cover, release_date, duration, artist_id) VALUES
('A Night at the Opera', 'https://e-cdns-images.dzcdn.net/images/cover/9922250d03c5d67615967f67756f3f72/500x500-000000-80-0-0.jpg', '1975-11-21', 2588000000000, 1), -- PT43M8S
('Random Access Memories', 'https://e-cdns-images.dzcdn.net/images/cover/b1e938925348342217c92b2361b427b5/500x500-000000-80-0-0.jpg', '2013-05-17', 4468000000000, 2), -- PT1H14M28S
('AM', 'https://e-cdns-images.dzcdn.net/images/cover/7e6c0c273a01c4c34aa245c11030e463/500x500-000000-80-0-0.jpg', '2013-09-09', 2517000000000, 3), -- PT41M57S
('Dois', 'https://e-cdns-images.dzcdn.net/images/cover/9079de9b084930198f3952f4a569a710/500x500-000000-80-0-0.jpg', '1986-07-01', 2803000000000, 4); -- PT46M43S

-- Músicas (com a coluna 'duration' corrigida para nanossegundos)
INSERT INTO song (title, duration, bpm, gain, album_id, artist_id) VALUES
('Bohemian Rhapsody', 354000000000, 71.10, -1.0, 1, 1),      -- PT5M54S
('Love of My Life', 218000000000, 115.32, -2.5, 1, 1),       -- PT3M38S
('You''re My Best Friend', 172000000000, 119.8, -1.5, 1, 1), -- PT2M52S
('Get Lucky', 369000000000, 116.0, -0.5, 2, 2),            -- PT6M9S
('Instant Crush', 337000000000, 110.0, -1.2, 2, 2),         -- PT5M37S
('Lose Yourself to Dance', 353000000000, 100.1, -0.8, 2, 2),-- PT5M53S
('Do I Wanna Know?', 272000000000, 85.0, -0.9, 3, 3),      -- PT4M32S
('R U Mine?', 201000000000, 98.5, -0.7, 3, 3),            -- PT3M21S
('Why''d You Only Call Me When You''re High?', 161000000000, 91.0, -1.1, 3, 3),-- PT2M41S
('Tempo Perdido', 302000000000, 125.0, -2.0, 4, 4),        -- PT5M2S
('Eduardo e Mônica', 271000000000, 110.5, -1.8, 4, 4),    -- PT4M31S
('Quase Sem Querer', 223000000000, 130.0, -2.2, 4, 4);      -- PT3M43S

-- Playlists (sem alteração)
INSERT INTO playlist (title, description, url_cover, author_id) VALUES
('Clássicos do Rock', 'O melhor do rock internacional e nacional.', 'https://e-cdns-images.dzcdn.net/images/cover/a4351052219e487859845016c49c4c47/500x500-000000-80-0-0.jpg', 1),
('Indie & Alternativo 2010s', 'Uma seleção de hits que marcaram a década de 2010.', 'https://e-cdns-images.dzcdn.net/images/cover/9e3c1533036e76166164f26b5e1b1d16/500x500-000000-80-0-0.jpg', 1),
('Festa em Casa', 'Para animar qualquer ambiente!', 'https://e-cdns-images.dzcdn.net/images/cover/0c70df447101683a308960f22f51199a/500x500-000000-80-0-0.jpg', 1);

-- Relação Playlist <-> Músicas (sem alteração)
INSERT INTO playlist_songs (playlist_id, song_id) VALUES
(1, 1), (1, 2), (1, 10), (1, 11),
(2, 7), (2, 8), (2, 9),
(3, 4), (3, 6), (3, 7), (3, 1);
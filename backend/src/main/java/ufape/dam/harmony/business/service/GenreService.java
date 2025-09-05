package ufape.dam.harmony.business.service;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import ufape.dam.harmony.business.dto.res.GenreListResponseDto;
import ufape.dam.harmony.business.dto.res.GenreResponseDTO;
import ufape.dam.harmony.business.entity.Album;
import ufape.dam.harmony.business.entity.Artist;
import ufape.dam.harmony.business.entity.Genre;
import ufape.dam.harmony.business.entity.Song;
import ufape.dam.harmony.data.AlbumRepository;
import ufape.dam.harmony.data.ArtistRepository;
import ufape.dam.harmony.data.GenreRepository;
import ufape.dam.harmony.data.SongRepository;

@Service
public class GenreService {

	@Autowired
	private GenreRepository genreRepository;

	@Autowired
	private SongRepository songRepository;
	
	@Autowired
	private ArtistRepository artistRepository;
	
	@Autowired
	private AlbumRepository albumRepository;

    @Transactional(readOnly = true)
    public Optional<GenreResponseDTO> findByIdWithArtistsAlbumsSongs(Long id) {
        Optional<Genre> genreOptional = genreRepository.findById(id);

        if (genreOptional.isEmpty()) {
            return Optional.empty();
        }
        
        Genre genre = genreOptional.get();

        PageRequest top10 = PageRequest.of(0, 10);
        
        List<Artist> topArtists = artistRepository.findTopArtistsBySongCountInGenre(id, top10);
        List<Album> recentAlbums = albumRepository.findTop10ByGenreIdOrderByReleasedDateDesc(id);
        List<Song> topSongs = songRepository.findAllByArtistId(id); //TODO: Otimizar com paginacao

        GenreResponseDTO response = GenreResponseDTO.fromEntity(genre, recentAlbums, topSongs, topArtists);

        return Optional.of(response);
    }
    

    @Transactional(readOnly = true)
    public List<GenreListResponseDto> findAll() {
        return genreRepository.findAll()
        		.stream()
        		.map(GenreListResponseDto::fromEntity)
        		.collect(Collectors.toList());
    }
}
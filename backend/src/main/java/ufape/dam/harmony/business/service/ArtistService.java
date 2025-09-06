package ufape.dam.harmony.business.service;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import ufape.dam.harmony.business.dto.res.ArtistResponseDTO;
import ufape.dam.harmony.business.dto.res.ArtistResponseDTO;
import ufape.dam.harmony.business.entity.Artist;
import ufape.dam.harmony.business.entity.Album;
import ufape.dam.harmony.business.entity.Song;
import ufape.dam.harmony.data.ArtistRepository;
import ufape.dam.harmony.data.AlbumRepository;
import ufape.dam.harmony.data.SongRepository;


@Service
public class ArtistService {
	
	@Autowired
	private ArtistRepository artistRepository;

	@Autowired
	private AlbumRepository albumRepository;

	@Autowired
	private SongRepository songRepository;
	

	@Transactional(readOnly = true)
	public Optional<ArtistResponseDTO> findByIdWithAlbumsAndSongs(Long id){
        Optional<Artist> artistOptional = artistRepository.findById(id);
		
		if (artistOptional.isEmpty()) {
			return Optional.empty();
		}
		
		Artist artist = artistOptional.get();

		List<Album> albums = albumRepository.findAllByArtistId(artist.getId());
		List<Song> songs = songRepository.findAllByArtistId(artist.getId());


		ArtistResponseDTO response = ArtistResponseDTO.fromEntity(artist, albums, songs);

		return Optional.of(response);
	}


	public Optional<ArtistResponseDTO> findById(Long id) {
        Optional<Artist> artistOptional = artistRepository.findById(id);
		
		if (artistOptional.isEmpty()) {
			return Optional.empty();
		}
		
		Artist artist = artistOptional.get();

		ArtistResponseDTO response = ArtistResponseDTO.fromEntity(artist, null, null);

		return Optional.of(response);
	}
}
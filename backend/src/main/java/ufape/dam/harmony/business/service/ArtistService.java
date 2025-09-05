package ufape.dam.harmony.business.service;

import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ufape.dam.harmony.business.dto.res.AlbumResponseDTO;
import ufape.dam.harmony.business.dto.res.ArtistResponseDTO;
import ufape.dam.harmony.business.entity.Artist;
import ufape.dam.harmony.data.ArtistRepository;

@Service
public class ArtistService {
	
	@Autowired
	private ArtistRepository artistRepository;
	
	public Optional<ArtistResponseDTO> findById(Long id) {
        return artistRepository.findById(id)
        		.map(ArtistResponseDTO::fromEntity);
    }
	
	public Optional<ArtistResponseDTO> findByIdWithAlbums(Long id){
        return artistRepository.findByIdWithAlbums(id)
        		.map(ArtistResponseDTO::fromEntityWithAlbums);
	}
	
	public Optional<ArtistResponseDTO> findByIdWithAlbumsAndSongs(Long id){
        return null;
	}
}

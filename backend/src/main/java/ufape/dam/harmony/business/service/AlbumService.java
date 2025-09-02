package ufape.dam.harmony.business.service;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ufape.dam.harmony.business.dto.res.AlbumResponseDTO;
import ufape.dam.harmony.business.entity.Album;
import ufape.dam.harmony.data.AlbumRepository;

@Service
public class AlbumService {
	
	@Autowired
	private AlbumRepository albumRepository;

    public Optional<AlbumResponseDTO> findById(Long id) {
        return albumRepository.findById(id)
        		.map(AlbumResponseDTO::fromEntity);
    }
    
    public Optional<AlbumResponseDTO> findByIdWithSongs(Long id) {
        return albumRepository.findByIdWithSongs(id)
        		.map(AlbumResponseDTO::fromEntity);
    }

    public List<AlbumResponseDTO> findAll() {
    	
    	List<Album> entities = albumRepository.findAll();
    	
    	return entities.stream()
                .map(AlbumResponseDTO::fromEntity)
                .collect(Collectors.toList());
    }


}
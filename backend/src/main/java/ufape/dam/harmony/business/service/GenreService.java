package ufape.dam.harmony.business.service;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ufape.dam.harmony.business.dto.res.AlbumResponseDTO;
import ufape.dam.harmony.business.dto.res.GenreListResponseDto;
import ufape.dam.harmony.business.dto.res.GenreResponseDTO;
import ufape.dam.harmony.business.entity.Genre;
import ufape.dam.harmony.data.AlbumRepository;
import ufape.dam.harmony.data.GenreRepository;

@Service
public class GenreService {

	@Autowired
	private GenreRepository genreRepository;
	
    public Optional<GenreResponseDTO> findById(Long id) {
        return genreRepository.findByIdWithAlbums(id)
        		.map(GenreResponseDTO::fromEntity);
    }
    
    public List<GenreListResponseDto> findAll() {
        return genreRepository.findAll()
        		.stream()
        		.map(GenreListResponseDto::fromEntity)
        		.collect(Collectors.toList());
    }
}

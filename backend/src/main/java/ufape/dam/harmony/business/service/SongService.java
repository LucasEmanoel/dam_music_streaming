package ufape.dam.harmony.business.service;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import ufape.dam.harmony.business.dto.res.SongResponseDTO;
import ufape.dam.harmony.data.SongRepository;

@Service
public class SongService {

    @Autowired
    private SongRepository songRepository;

    public List<SongResponseDTO> findAllSongs() {
        return songRepository.findAll().stream()
                .map(SongResponseDTO::fromEntity)
                .collect(Collectors.toList());
    }

    public List<SongResponseDTO> searchSongs(String q) {
    	PageRequest limit = PageRequest.of(0, 50);
    	
        return songRepository.findByTitleContainingIgnoreCase(q, limit).stream()
                .map(SongResponseDTO::fromEntity)
                .collect(Collectors.toList());
    }

    public List<SongResponseDTO> findAlbumSongs(Long albumId) {
        Pageable limit = PageRequest.of(0, 10, Sort.by("title").ascending());
        
        return songRepository.findAllByAlbumId(albumId, limit).stream()
                .map(SongResponseDTO::fromEntity)
                .collect(Collectors.toList());
    }

    public SongResponseDTO findById(Long id) {
        return songRepository.findById(id)
                .map(SongResponseDTO::fromEntity)
                .orElseThrow(() -> new RuntimeException("Song not found with id: " + id));
    }
}
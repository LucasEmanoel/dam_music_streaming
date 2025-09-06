package ufape.dam.harmony.business.service;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import ufape.dam.harmony.business.dto.res.AlbumResponseDTO;
import ufape.dam.harmony.business.entity.Album;
import ufape.dam.harmony.business.entity.Song;
import ufape.dam.harmony.data.AlbumRepository;
import ufape.dam.harmony.data.SongRepository;

@Service
public class AlbumService {
	
	@Autowired
	private AlbumRepository albumRepository;

    @Autowired
    private SongRepository songRepository;


    @Transactional(readOnly = true)
    public Optional<AlbumResponseDTO> findByIdWithSongs(Long id) {
        Optional<Album> albumOptional = albumRepository.findById(id);

        if (albumOptional.isEmpty()) {
            return Optional.empty();
        }

        Album album = albumOptional.get();
        List<Song> songs = songRepository.findAllByAlbumId(album.getId());
        AlbumResponseDTO dto = AlbumResponseDTO.fromEntity(album, songs);
        
        return Optional.of(dto);
    }
    
    public Optional<AlbumResponseDTO> findById(Long id) {
        Optional<Album> albumOptional = albumRepository.findById(id);

        if (albumOptional.isEmpty()) {
            return Optional.empty();
        }
        Album album = albumOptional.get();
        
        AlbumResponseDTO dto = AlbumResponseDTO.fromEntity(album, null);
        
        return Optional.of(dto);
    }
}
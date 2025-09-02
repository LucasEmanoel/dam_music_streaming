package ufape.dam.harmony.business.service;

import java.time.Duration;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import ufape.dam.harmony.business.dto.reqs.TestSaveSong;
import ufape.dam.harmony.business.entity.Album;
import ufape.dam.harmony.business.entity.Artist;
import ufape.dam.harmony.business.entity.Song;
import ufape.dam.harmony.data.AlbumRepository;
import ufape.dam.harmony.data.ArtistRepository;
import ufape.dam.harmony.data.SongRepository;

@Service
public class SongService {
	
	@Autowired
	private SongRepository songRepository;

	@Autowired
	private AlbumRepository albumRepository;
	
	@Autowired
	private ArtistRepository artistRepository;

    public Song saveSong(Song song) {
        return songRepository.save(song);
    }
    
    @Transactional
    public Song saveSong(TestSaveSong dto) {
    	Song song = songRepository.findById(dto.getId())
    			.orElseThrow(() -> new RuntimeException("Album com id " + dto.getAlbumId() + " não encontrado."));

        Album album = albumRepository.findById(dto.getAlbumId())
            .orElseThrow(() -> new RuntimeException("Album com id " + dto.getAlbumId() + " não encontrado."));

        Artist artist = artistRepository.findById(dto.getArtistId())
            .orElseThrow(() -> new RuntimeException("Artista com id " + dto.getArtistId() + " não encontrado."));

        Song newSong = new Song();
        newSong.setId(dto.getId());
        newSong.setTitle(dto.getTitle());
        newSong.setBpm(dto.getBpm());
        newSong.setGain(dto.getGain());

        newSong.setDuration(Duration.ofSeconds(dto.getDuration()));

        newSong.setAlbum(album);
        newSong.setArtist(artist);

        return songRepository.save(newSong);
    }
    
    public Optional<Song> findSongById(Long id) {
        return songRepository.findById(id);
    }

    public List<Song> findAllSongs() {
        return songRepository.findAll();
    }

    public void deleteSong(Long id) {
        songRepository.deleteById(id);
    }
    
}

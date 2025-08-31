package ufape.dam.harmony.business.service;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ufape.dam.harmony.business.entity.Song;
import ufape.dam.harmony.data.SongRepository;

@Service
public class SongService {
	@Autowired
	private SongRepository songRepository;


    public Song saveSong(Song song) {
        return songRepository.save(song);
    }

    public Optional<Song> findSongById(Long id) {
        return songRepository.findById(id);
    }

    public Optional<Song> findSongByApiId(String apiId) {
        return songRepository.findByApiId(apiId);
    }

    public List<Song> findAllSongs() {
        return songRepository.findAll();
    }

    public void deleteSong(Long id) {
        songRepository.deleteById(id);
    }
}

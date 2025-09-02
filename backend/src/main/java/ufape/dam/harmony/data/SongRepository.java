package ufape.dam.harmony.data;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import ufape.dam.harmony.business.entity.Song;

public interface SongRepository extends JpaRepository<Song, Long>{
	
	Optional<Song> findById(Long apiId);
	
}

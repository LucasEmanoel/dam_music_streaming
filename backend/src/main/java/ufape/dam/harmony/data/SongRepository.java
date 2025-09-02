package ufape.dam.harmony.data;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import ufape.dam.harmony.business.entity.Song;

public interface SongRepository extends JpaRepository<Song, Long>{
	
	
	@Query("SELECT s FROM Song s LEFT JOIN FETCH s.album LEFT JOIN FETCH s.artist WHERE s.id = :id")
    Optional<Song> findByIdWithDetails(@Param("id") Long id);
}

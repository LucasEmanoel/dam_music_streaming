package ufape.dam.harmony.data;

import java.util.List;
import java.util.Optional;
import java.util.Set;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import ufape.dam.harmony.business.entity.Playlist;


public interface PlaylistRepository extends JpaRepository<Playlist, Long>{

	List<Playlist> findByAuthorId(Long authorId);
	
	@Query("SELECT p FROM Playlist p LEFT JOIN FETCH p.songs s LEFT JOIN FETCH p.author a WHERE p.id = :id")
	Optional<Playlist> findByIdWithSongs(@Param("id") Long id);

	@Query("SELECT p FROM Playlist p JOIN p.songs s WHERE s.genre.name IN :preferredGenres GROUP BY p ORDER BY COUNT(s) DESC")	
	Page<Playlist> findBySongsGenreName(Set<String> preferredGenres, Pageable top5);

	
	
}

package ufape.dam.harmony.data;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import ufape.dam.harmony.business.entity.Playlist;
import ufape.dam.harmony.business.entity.Usuario;


public interface PlaylistRepository extends JpaRepository<Playlist, Long>{

	List<Playlist> findByAuthorId(Long authorId);
	
	@Query("SELECT p FROM Playlist p LEFT JOIN FETCH p.songs s LEFT JOIN FETCH p.author a WHERE p.id = :id")
	Optional<Playlist> findByIdWithSongs(@Param("id") Long id);

}

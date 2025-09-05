package ufape.dam.harmony.data;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import ufape.dam.harmony.business.entity.Artist;

public interface ArtistRepository extends JpaRepository<Artist, Long> {
	
	@Query("SELECT a FROM Artist a LEFT JOIN FETCH a.albums LEFT JOIN FETCH a.songs WHERE a.id = :id")
    Optional<Artist> findByIdWithAlbumsAndSongs(@Param("id") Long id);
	
	@Query("SELECT a FROM Artist a LEFT JOIN FETCH a.albums WHERE a.id = :id")
	Optional<Artist> findByIdWithAlbums(@Param("id") Long id);
}

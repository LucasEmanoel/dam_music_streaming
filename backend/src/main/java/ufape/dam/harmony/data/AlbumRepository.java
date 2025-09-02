package ufape.dam.harmony.data;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import ufape.dam.harmony.business.entity.Album;

public interface AlbumRepository extends JpaRepository<Album, Long> {
	
	@Query("SELECT a FROM Album a LEFT JOIN FETCH a.songs WHERE a.id = :id")
    Optional<Album> findByIdWithSongs(@Param("id") Long id);
}

package ufape.dam.harmony.data;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import ufape.dam.harmony.business.entity.Album;
import ufape.dam.harmony.business.entity.Genre;

public interface GenreRepository extends JpaRepository<Genre, Long> {
	@Query("SELECT g FROM Genre g LEFT JOIN FETCH g.albums WHERE g.id = :id")
    Optional<Genre> findByIdWithAlbums(@Param("id") Long id);
}

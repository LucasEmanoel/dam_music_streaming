package ufape.dam.harmony.data;

import java.awt.print.Pageable;
import java.util.List;

import org.springframework.data.domain.PageRequest;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import ufape.dam.harmony.business.entity.Artist;

public interface ArtistRepository extends JpaRepository<Artist, Long> {

	@Query("SELECT a FROM Artist a JOIN a.songs s WHERE s.genre.id = :genreId GROUP BY a ORDER BY COUNT(s) DESC")
    List<Artist> findTopArtistsBySongCountInGenre(@Param("genreId") Long genreId, PageRequest limit);
}

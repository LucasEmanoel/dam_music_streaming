package ufape.dam.harmony.data;

import java.util.List;
import java.util.Optional;

import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import ufape.dam.harmony.business.entity.Album;

public interface AlbumRepository extends JpaRepository<Album, Long> {
	
	List<Album> findAllByArtistId(Long id, Pageable limit);
	List<Album> findTop10ByGenreIdOrderByReleasedDateDesc(Long id, Pageable limit);
}

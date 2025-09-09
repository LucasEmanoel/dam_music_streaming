package ufape.dam.harmony.data;

import java.util.List;
import java.util.Set;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import ufape.dam.harmony.business.entity.Song;

public interface SongRepository extends JpaRepository<Song, Long>{

	List<Song> findAllByArtistId(Long artistId, Pageable limit);
	List<Song> findAllByAlbumId(Long id, Pageable limit);
	//title
	List<Song> findByTitleContainingIgnoreCase(String q, Pageable limit);
	//trackPosition
	@Query("SELECT s FROM Song s JOIN s.genre g WHERE g.name IN :preferredGenres ORDER BY s.rank DESC")
	Page<Song> findByGenreName(Set<String> preferredGenres, Pageable limit);
	
	
}

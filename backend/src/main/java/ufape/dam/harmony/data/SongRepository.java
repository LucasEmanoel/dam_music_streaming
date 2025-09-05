package ufape.dam.harmony.data;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import ufape.dam.harmony.business.entity.Song;

public interface SongRepository extends JpaRepository<Song, Long>{

	List<Song> findAllByArtistId(Long artistId);
	List<Song> findAllByAlbumId(Long id);
	//title
	List<Song> findByTitleContainingIgnoreCase(String q);
}

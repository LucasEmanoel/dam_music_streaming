package ufape.dam.harmony.data;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import ufape.dam.harmony.business.entity.Album;
import ufape.dam.harmony.business.entity.Artist;

public interface ArtistRepository extends JpaRepository<Artist, Long> {
	

}

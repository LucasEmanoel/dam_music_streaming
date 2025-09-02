package ufape.dam.harmony.business.service;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ufape.dam.harmony.business.entity.Artist;
import ufape.dam.harmony.data.ArtistRepository;

@Service
public class ArtistService {
	
	@Autowired
	private ArtistRepository artistRepository;
	
	public Optional<Artist> findById(Long id) {
        return artistRepository.findById(id);
    }

}

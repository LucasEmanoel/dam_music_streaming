package ufape.dam.harmony.presentation;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import ufape.dam.harmony.business.dto.res.ArtistResponseDTO;
import ufape.dam.harmony.business.service.ArtistService;

@RestController
@RequestMapping("/artists") 
public class ArtistController {

	@Autowired
	private ArtistService artistService;
	
	@GetMapping("/{id}")
    public ResponseEntity<ArtistResponseDTO> getArtistById(@PathVariable Long id) {
		
		ArtistResponseDTO artist = artistService.findById(id).orElse(null);
		
        return ResponseEntity.ok(artist);
    }
	
	@GetMapping("/{id}/items")
    public ResponseEntity<ArtistResponseDTO> getArtistItemsById(@PathVariable Long id) {
		
		ArtistResponseDTO artist = artistService.findByIdWithAlbumsAndSongs(id).orElse(null);
		
        return ResponseEntity.ok(artist);
    }
}

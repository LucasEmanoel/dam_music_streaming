package ufape.dam.harmony.presentation;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import ufape.dam.harmony.business.dto.res.AlbumResponseDTO;
import ufape.dam.harmony.business.service.AlbumService;

@RestController
@RequestMapping("/albums") 
public class AlbumController {

	@Autowired
	private AlbumService albumService;
	
	@GetMapping("/{id}")
    public ResponseEntity<AlbumResponseDTO> getAlbumById(@PathVariable Long id) {
		AlbumResponseDTO album = albumService.findByIdWithSongs(id).orElse(null);
		return ResponseEntity.ok(album);

    }
}

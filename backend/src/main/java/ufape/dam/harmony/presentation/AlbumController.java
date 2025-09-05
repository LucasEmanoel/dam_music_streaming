package ufape.dam.harmony.presentation;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import ufape.dam.harmony.business.dto.res.AlbumResponseDTO;
import ufape.dam.harmony.business.dto.res.SongResponseDTO;
import ufape.dam.harmony.business.service.AlbumService;

@RestController
@RequestMapping("/albums") 
public class AlbumController {

	@Autowired
	private AlbumService albumService;
	
	@GetMapping("/{id}")
    public ResponseEntity<AlbumResponseDTO> getAlbumById(@PathVariable Long id) {
		AlbumResponseDTO album = albumService.findById(id).orElse(null);
		return ResponseEntity.ok(album);

    }
	
	@GetMapping("/{id}/songs")
	public ResponseEntity<AlbumResponseDTO> getSongsAlbum(@PathVariable Long id){
		try {
			
			AlbumResponseDTO album = albumService.findByIdWithSongs(id).orElse(null);
			
			return ResponseEntity.ok(album);
			
		} catch (Exception e) {
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
		}
	}
}

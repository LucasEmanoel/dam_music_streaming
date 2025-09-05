package ufape.dam.harmony.presentation;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import ufape.dam.harmony.business.dto.res.SongResponseDTO;
import ufape.dam.harmony.business.service.SongService;

@RestController
@RequestMapping("/songs")
public class SongController {
	
	@Autowired
	private SongService service;

	@GetMapping
	public ResponseEntity<List<SongResponseDTO>> findAllSongs(){
		try {
			List<SongResponseDTO> songs = service.findAllSongs();
			return ResponseEntity.ok(songs);
		} catch (Exception e) {
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
		}
	}
	
	@GetMapping("/search")
	public ResponseEntity<List<SongResponseDTO>> searchSongs(@RequestParam String q) {
		try {
			List<SongResponseDTO> songs = service.searchSongs(q);
			return ResponseEntity.ok(songs);
		} catch (Exception e) {
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
		}
	}

	

	@GetMapping("/{idSong}")
	public ResponseEntity<SongResponseDTO> getSong(@PathVariable Long idSong){
		try {
			SongResponseDTO song = service.findById(idSong);
			return ResponseEntity.ok(song);
		} catch (Exception e) {
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
		}
	}
}
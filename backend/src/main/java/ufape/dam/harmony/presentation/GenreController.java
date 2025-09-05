package ufape.dam.harmony.presentation;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import ufape.dam.harmony.business.dto.res.GenreListResponseDto;
import ufape.dam.harmony.business.dto.res.GenreResponseDTO;
import ufape.dam.harmony.business.service.GenreService;

@RestController
@RequestMapping("/genres") 
public class GenreController {
	@Autowired
	private GenreService genreService;
	
	@GetMapping("/")
    public ResponseEntity<List<GenreListResponseDto>> getAllGenres() {
		List<GenreListResponseDto> list = genreService.findAll();
		return ResponseEntity.ok(list);
    }
	
	@GetMapping("/{id}")
    public ResponseEntity<GenreResponseDTO> getAlbumById(@PathVariable Long id) {
		GenreResponseDTO genre = genreService.findById(id).orElse(null);
		return ResponseEntity.ok(genre);
    }
}

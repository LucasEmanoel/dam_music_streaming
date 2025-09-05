package ufape.dam.harmony.presentation;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.util.List;

import org.apache.http.client.utils.URIBuilder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.fasterxml.jackson.databind.ObjectMapper;

import ufape.dam.harmony.business.dto.deezer.AlbumSongsDeezerDTO;
import ufape.dam.harmony.business.dto.deezer.SearchDeezerDTO;
import ufape.dam.harmony.business.dto.deezer.SongDeezerDTO;
import ufape.dam.harmony.business.entity.Song;
import ufape.dam.harmony.business.service.SongService;

@RestController
@RequestMapping("/songs")
public class SongController {
	
	@Autowired
	private SongService service;
	
	private final ObjectMapper objectMapper = new ObjectMapper();
	
	private final HttpClient httpClient = HttpClient.newHttpClient();
		
	private final String deezerApiBaseUrl = "https://api.deezer.com/track/";
	private final String deezerSearchUrl = "https://api.deezer.com/search/track";
	private final String deezerAlbumSongsUrl = "https://api.deezer.com/album/";
	
	@GetMapping
	public ResponseEntity<String> fetchSongs(){
		
		List<Song> songs = service.findAllSongs();
		
		return ResponseEntity
				.status(HttpStatus.ACCEPTED)
				.body("ok");
	}
	
	@GetMapping("/{idAlbum}/album_list")
	public ResponseEntity<List<SongDeezerDTO>> getSongsAlbum(@PathVariable String idAlbum){
		String finalUrl = deezerAlbumSongsUrl + idAlbum + "/tracks";
		
		try {
			
            HttpRequest request = HttpRequest.newBuilder().uri(URI.create(finalUrl)).GET().build();
            HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());
            
            AlbumSongsDeezerDTO deezerResponse = 
                    objectMapper.readValue(response.body(), AlbumSongsDeezerDTO.class);
            
            List<SongDeezerDTO> songs = deezerResponse.getData();
            
            return ResponseEntity.ok(songs);
            
		} catch (IOException | InterruptedException e) {
        	e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build(); 
        }
	}
	
	@GetMapping("/{idSong}")
	public ResponseEntity<SongDeezerDTO> getSong(@PathVariable String idSong){		
		String finalUrl = deezerApiBaseUrl + idSong;
		
		try {
			

            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(finalUrl))
                    .GET()
                    .build();

            HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());
            SongDeezerDTO deezerSong = objectMapper.readValue(response.body(), SongDeezerDTO.class);
            
            return ResponseEntity.ok(deezerSong);

        } catch (IOException | InterruptedException e) {
        	e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build(); 
        }
	}
	
	@GetMapping("/search")
	public ResponseEntity<List<SongDeezerDTO>> searchSongs(@RequestParam String q) {
		
		try {

			var client = HttpClient.newHttpClient();
			
			URI uri = new URIBuilder(deezerSearchUrl)
		            .addParameter("q", q)
		            .addParameter("type", "track")
		            .build();
			
			var request = HttpRequest.newBuilder(uri)
		            .GET()
		            .build();
			
			var response = client.send(request, HttpResponse.BodyHandlers.ofString());
			
			SearchDeezerDTO deezerResponse = objectMapper.readValue(
	                response.body(), 
	                SearchDeezerDTO.class
	            );
			
			return ResponseEntity
					.status(response.statusCode())
					.body(deezerResponse.getData());

		} catch (Exception e) {
			e.printStackTrace(); 
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
		}
	}
}

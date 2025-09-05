package ufape.dam.harmony.presentation;

import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import ufape.dam.harmony.business.dto.reqs.PlaylistRequestDTO;
import ufape.dam.harmony.business.dto.res.PlaylistResponseDTO;
import ufape.dam.harmony.business.entity.Playlist;
import ufape.dam.harmony.business.entity.Song;
import ufape.dam.harmony.business.service.PlaylistService;
import ufape.dam.harmony.security.SecurityUser;

@RestController
@RequestMapping("/playlists")
public class PlaylistController {
	
	@Autowired
	private PlaylistService service;
	
	@PostMapping
    public ResponseEntity<PlaylistResponseDTO> createPlaylist(
            @RequestBody PlaylistRequestDTO request,
            @AuthenticationPrincipal SecurityUser user) {

        PlaylistResponseDTO saved = service.createPlaylist(request, user);
        return ResponseEntity.ok(saved); 
    }
	
	@GetMapping
    public ResponseEntity<List<PlaylistResponseDTO>> getUserPlaylists(@AuthenticationPrincipal SecurityUser user) {
        List<PlaylistResponseDTO> userPlaylists = service.listPlaylistsByUser(user);
        return ResponseEntity.ok(userPlaylists);
    }


	@GetMapping("/{playlistId}")
    public ResponseEntity<PlaylistResponseDTO> getPlaylistById(@PathVariable Long playlistId) {
        PlaylistResponseDTO playlist = service.findPlaylistByIdWithSongs(playlistId); 
        return ResponseEntity.ok(playlist);
    }
	
	@PutMapping("/{playlistId}")
    public ResponseEntity<PlaylistResponseDTO> updatePlaylist(
            @PathVariable Long playlistId,
            @RequestBody PlaylistRequestDTO request,
            @AuthenticationPrincipal SecurityUser user) {
        
		PlaylistResponseDTO updated = service.updatePlaylist(playlistId, request, user);
        return ResponseEntity.ok(updated);
    }
	
	@DeleteMapping("/{playlistId}")
    public ResponseEntity<Void> deletePlaylist(
            @PathVariable Long playlistId,
            @AuthenticationPrincipal SecurityUser user) {
        
        service.deletePlaylist(playlistId, user);
        return ResponseEntity.noContent().build();
    }
	
	
	@GetMapping("/{playlistId}/songs")
    public ResponseEntity<PlaylistResponseDTO> listPlaylistSongs(@PathVariable Long playlistId) {
        PlaylistResponseDTO songs = service.findPlaylistByIdWithSongs(playlistId); 
        return ResponseEntity.ok(songs);
    }
	
	//@PostMapping("/{playlistId}/song")
    //public ResponseEntity<PlaylistResponseDTO> addSongUserPlaylists(@PathVariable Long playlistId, @AuthenticationPrincipal SecurityUser user, @RequestBody PlaylistSongDto song) {
		
	//	Playlist saved = service.addSongToPlaylist(user, song, playlistId);
		
    //    return ResponseEntity.ok(PlaylistResponseDTO.fromEntity(saved));
    //}
	
//	@PostMapping("/{playlistId}/songs")
//	public ResponseEntity<PlaylistResponseDTO> addSongsUserPlaylists(@PathVariable Long playlistId, @AuthenticationPrincipal SecurityUser user, @RequestBody PlaylistSongsDto songs) {
//		
//		Playlist saved = service.addSongToPlaylist(user, playlistId, songs.getSongIds());
//		
//        return ResponseEntity.ok(PlaylistResponseDTO.fromEntity(saved));
//    }
//	
//	@DeleteMapping("/{playlistId}/songs/{songId}")
//    public ResponseEntity<Void> deleteSongFromPlaylist(
//            @PathVariable Long playlistId,
//            @PathVariable Long songId,
//            @AuthenticationPrincipal SecurityUser user) {
//        
//        service.removeSongFromPlaylist(playlistId, user, songId);
//        return ResponseEntity.noContent().build();
//    }
	
	
	
	
	
	
}

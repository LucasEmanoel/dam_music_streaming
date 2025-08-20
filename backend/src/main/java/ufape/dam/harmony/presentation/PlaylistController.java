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

import ufape.dam.harmony.business.dto.PlaylistSongDto;
import ufape.dam.harmony.business.dto.PlaylistDto;
import ufape.dam.harmony.business.dto.PlaylistWithSongsDto;
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
    public ResponseEntity<PlaylistDto> createPlaylist(
            @RequestBody PlaylistDto request,
            @AuthenticationPrincipal SecurityUser user) {

        Playlist saved = service.createPlaylist(request, user);
        
        return ResponseEntity.ok(PlaylistDto.fromEntity(saved)); 
    }
	
	@GetMapping
    public ResponseEntity<List<PlaylistDto>> getUserPlaylists(@AuthenticationPrincipal SecurityUser user) {
        List<Playlist> userPlaylists = service.listPlaylistsByUser(user);
        
        List<PlaylistDto> dtos = userPlaylists.stream()
                .map(PlaylistDto::fromEntity)
                .collect(Collectors.toList());
        
        return ResponseEntity.ok(dtos);
    }

	
	
	
	@GetMapping("/{playlistId}")
    public ResponseEntity<PlaylistWithSongsDto> getPlaylistById(@PathVariable Long playlistId) {
        Playlist playlist = service.findPlaylistById(playlistId); 
        return ResponseEntity.ok(PlaylistWithSongsDto.fromEntity(playlist));
    }
	
	@PutMapping("/{playlistId}")
    public ResponseEntity<PlaylistDto> updatePlaylist(
            @PathVariable Long playlistId,
            @RequestBody PlaylistDto request,
            @AuthenticationPrincipal SecurityUser user) {
        
        Playlist updated = service.updatePlaylist(playlistId, request, user);
        return ResponseEntity.ok(PlaylistDto.fromEntity(updated));
    }
	
	@DeleteMapping("/{playlistId}")
    public ResponseEntity<Void> deletePlaylist(
            @PathVariable Long playlistId,
            @AuthenticationPrincipal SecurityUser user) {
        
        service.deletePlaylist(playlistId, user);
        return ResponseEntity.noContent().build();
    }
	
	
	
	
	@GetMapping("/{playlistId}/songs")
    public ResponseEntity<Set<Song>> listPlaylistSongs(@PathVariable Long playlistId) {
        Set<Song> songs = service.listPlaylistSongs(playlistId); 
        return ResponseEntity.ok(songs);
    }
	
	@PostMapping("/{playlistId}/songs")
    public ResponseEntity<Playlist> addSongUserPlaylists(@PathVariable Long playlistId, @AuthenticationPrincipal SecurityUser user, @RequestBody PlaylistSongDto song) {
		
		Playlist saved = service.addSongToPlaylist(user, song, playlistId);
		
        return ResponseEntity.ok(saved);
    }
	
	@DeleteMapping("/{playlistId}/songs/{songId}")
    public ResponseEntity<Void> deleteSongFromPlaylist(
            @PathVariable Long playlistId,
            @PathVariable Long songId,
            @AuthenticationPrincipal SecurityUser user) {
        
        service.removeSongFromPlaylist(playlistId, user, songId);
        return ResponseEntity.noContent().build();
    }
	
	
	
	
	
	
}

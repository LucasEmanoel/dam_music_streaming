package ufape.dam.harmony.business.service;

import java.util.List;
import java.util.Objects;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import jakarta.persistence.EntityNotFoundException;
import ufape.dam.harmony.business.dto.reqs.PlaylistDto;
import ufape.dam.harmony.business.dto.reqs.PlaylistSongDto;
import ufape.dam.harmony.business.entity.Playlist;
import ufape.dam.harmony.business.entity.Song;
import ufape.dam.harmony.business.entity.Usuario;
import ufape.dam.harmony.data.PlaylistRepository;
import ufape.dam.harmony.data.SongRepository;
import ufape.dam.harmony.security.SecurityUser;

@Service
public class PlaylistService {
	
	@Autowired
	private PlaylistRepository repository;

	@Autowired
	private SongRepository songRepository;

	public Set<Song> listPlaylistSongs(Long playlistId){
		Playlist playlist = repository.findByIdWithSongs(playlistId)
	            .orElseThrow(() -> new EntityNotFoundException("Playlist não encontrada."));
		
		return playlist.getSongs();
	}
	
	public Playlist createPlaylist(PlaylistDto request, SecurityUser user) {
		
		Usuario userEntity = user.getUsuario(); 
		Playlist createdPlaylist = PlaylistDto.toEntity(request, userEntity);
		
        return repository.save(createdPlaylist);
    }
	
	public Playlist addSongToPlaylist(SecurityUser user, PlaylistSongDto song, Long playlistId) {
		Usuario userEntity = user.getUsuario();
		
		Playlist playlist = findPlaylistByIdAndEnsureOwnership(playlistId, userEntity);
		System.out.println(song.toString());
		Song songRef = songRepository.findById(song.getId())
	            .orElseGet(() -> {
	                Song newSongRef = new Song();
	                
	                newSongRef.setId(song.getId());
	                newSongRef.setDuration(song.getDuration());

	                return songRepository.save(newSongRef);
	            });
		System.out.println(songRef.toString());
		
		boolean added = playlist.getSongs().add(songRef);
		
		if (added) {
			return repository.save(playlist);
		}
		
		return playlist;
	}
	
	@Transactional
	public Playlist addSongsToPlaylist(SecurityUser user, Long playlistId, List<Long> songApiIds) {
		Usuario userLogged = user.getUsuario();
		Playlist playlist = findPlaylistByIdAndEnsureOwnership(playlistId, userLogged);

	    List<Song> foundSongs = songRepository.findAllById(songApiIds); //ta assim pois iremos mudar para usar apenas musicas dentro do sistema.

	    if (!foundSongs.isEmpty()) {
	        playlist.getSongs().addAll(foundSongs);
	    }
	    
	    return repository.save(playlist);
	}
	
	
	public Playlist removeSongFromPlaylist(Long playlistId, SecurityUser user, Long songId) {
		Usuario userEntity = user.getUsuario(); 
        Playlist playlist = findPlaylistByIdAndEnsureOwnership(playlistId, userEntity);
        Song songToRemove = songRepository.findById(songId)
        						.orElseThrow(() -> new EntityNotFoundException("Musica nao encontrada"));
        
        playlist.getSongs().remove(songToRemove);
        return repository.save(playlist);
        
	}
	
	//

    public List<Playlist> listPlaylistsByUser(SecurityUser user) {
		Usuario userEntity = user.getUsuario(); 
        return repository.findByAuthor(userEntity);
    }
	
    public Playlist findPlaylistById(Long playlistId) {
		Playlist playlist = repository.findByIdWithSongs(playlistId)
	            .orElseThrow(() -> new EntityNotFoundException("Playlist não encontrada."));
		
		return playlist;
    }
	
    public Playlist updatePlaylist(Long playlistId, PlaylistDto request, SecurityUser user) {
		Usuario userEntity = user.getUsuario(); 
        Playlist playlist = findPlaylistByIdAndEnsureOwnership(playlistId, userEntity);
        
        
        playlist.setTitle(request.getTitle());
        playlist.setDescription(request.getDescription());
        playlist.setUrlCover(request.getUrlCover());

        return repository.save(playlist);
    }
	
    public void deletePlaylist(Long playlistId, SecurityUser user) {
		Usuario userEntity = user.getUsuario(); 
        Playlist playlist = findPlaylistByIdAndEnsureOwnership(playlistId, userEntity);
        repository.delete(playlist);
    }
	
	private Playlist findPlaylistByIdAndEnsureOwnership(Long playlistId, Usuario user) {
        Playlist playlist = findPlaylistById(playlistId);
        if (!Objects.equals(playlist.getAuthor().getId(), user.getId())) {
            throw new SecurityException("Acesso negado");
        }
        return playlist;
    }
}
